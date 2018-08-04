require_relative '__base__'
module Eucalypt
  class CLI < Thor
    method_option :port, type: :numeric, aliases: '-p'
    desc "boot [ENV]", "Serves your application"
    def boot(env = ENV['RACK_ENV']||'development')
      unless %w[production development test].include? env
        puts "\e[1;91mERROR\e[0m: Invalid Rack environment \e[1m#{env}\e[0m."
        return
      end

      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        cmd = "bundle exec rackup -p #{options[:port]||9292}"
        puts "Running command: \e[1m#{cmd}\e[0m"
        puts "Rack environment: \e[1m#{env}\e[0m"
        exec "env RACK_ENV=#{env} #{cmd}"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end