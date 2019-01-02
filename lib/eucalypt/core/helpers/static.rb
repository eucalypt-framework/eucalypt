require 'sinatra'
module Eucalypt
  class Static::Router
    attr_reader :routes

    def initialize(public_folder)
      @routes = []
      @public_folder = public_folder
    end

    def route(file, aliases: [])
      raise ArgumentError.new("Invalid argument #{file} for 'file' - Expected string (file path with preceding /)") unless file.is_a?(String) && file.start_with?('/')
      location = File.join @public_folder, file.sub('/', '')
      raise ArgumentError.new("Invalid argument #{file} for 'file' - File \"#{location}\" doesn't exist") unless File.file? location
      raise ArgumentError.new("Invalid keyword argument #{aliases} for 'aliases' - Expected Array of String") unless aliases.is_a?(Array) && aliases.all?{|a| a.is_a? String}
      raise ArgumentError.new("Invalid keyword argument #{aliases} for 'aliases' - Expected Array of route names (preceded by /)") unless aliases.all?{|a| a.start_with? '/'}
      @routes << {file: file, aliases: aliases}
    end
  end
end

class ApplicationController < Sinatra::Base
  set :static_router, Eucalypt::Static::Router.new(settings.public_folder)

  def self.static(file = nil, aliases: [])
    if settings.static_router.is_a? Eucalypt::Static::Router
      if block_given?
        yield settings.static_router
        settings.static_router.routes.each do |route|
          route.values.flatten.each do |path|
            get(path) { send_file File.join(settings.public_folder, route[:file].sub('/','')) }
          end
        end
      else
        if file && aliases
          raise ArgumentError.new("Invalid argument #{file} for 'file' - Expected string (file path with preceding /)") unless file.is_a?(String) && file.start_with?('/')
          location = File.join settings.public_folder, file.sub('/', '')
          raise ArgumentError.new("Invalid argument #{file} for 'file' - File \"#{location}\" doesn't exist") unless File.file? location
          raise ArgumentError.new("Invalid keyword argument #{aliases} for 'aliases' - Expected Array of String") unless aliases.is_a?(Array) && aliases.all?{|a| a.is_a? String}
          raise ArgumentError.new("Invalid keyword argument #{aliases} for 'aliases' - Expected Array of route names (preceded by /)") unless aliases.all?{|a| a.start_with? '/'}
          routes = [file] + aliases
          routes.each {|path| get(path){send_file location} }
        end
      end
    end
  end
end