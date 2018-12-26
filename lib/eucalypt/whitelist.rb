require 'sinatra'
require 'bcrypt'
require_relative 'exceptions'
module Eucalypt
  class Whitelist
    def initialize(file)
      @file = file
      File.new(file, "a").close
      add '::1', '127.0.0.1', '0.0.0.0'
    end

    def add(*to_add)
      to_add.flatten.each do |ip|
        next if include? ip
        File.open(@file, 'a+') do |f|
          lines = File.readlines(@file)
          if lines.empty? || lines.all? {|line| line == "\n"}
            File.open(@file, 'w') do |f1|
              f1.write "#{BCrypt::Password.create(ip)}\n"
            end
          else
            prefix = f.read.last == "\n" ? '' : "\n"
            f.puts prefix + BCrypt::Password.create(ip)
          end
        end
      end
    end

    def remove(*to_remove)
      whitelist = []
      hashed = File.readlines(@file).select{|ip| /\$.*/.match ip}.map(&:strip)

      hashed.each do |ip|
        if to_remove.flatten.any? {|request| BCrypt::Password.new(ip) == request}
          next
        else
          whitelist << ip unless whitelist.include?(ip)
        end
      end

      File.open(@file, 'w') {|f| f.write whitelist*("\n")<<"\n"}
    end

    def ips()
      File.readlines(@file).map(&:strip).
        select{|ip| /\$.*/.match ip}.
        map {|ip| BCrypt::Password.new ip}
    end

    def include?(ip)
      ips.any? {|whitelisted| whitelisted == ip}
    end
  end
end

class ApplicationController < Sinatra::Base
  helpers do
    def whitelisted?
      case settings.whitelist
      when Eucalypt::Whitelist then settings.whitelist.include?(request.ip)
      when FalseClass          then true
      else raise Eucalypt::InvalidSettingTypeError.new(:whitelist, settings.whitelist.class, %w[FalseClass Eucalypt::Whitelist])
      end
    end

    def ipcheck()
      raise Eucalypt::NotWhitelistedError.new(request.ip) unless whitelisted?
    end
  end
end