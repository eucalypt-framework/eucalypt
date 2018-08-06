require_relative '__base__'
module Eucalypt
  class CLI < Thor
    method_option :port, type: :numeric, aliases: '-p'
    desc "launch [ENV]", "Serves your application".colorize(:grey)
    def launch(env = ENV['RACK_ENV']||'development')
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        unless %w[production development test].include? env
          Out.error "Invalid Rack environment #{env.colorize(:bold)}"
          return
        end

        cmd = "bundle exec rackup -p #{options[:port]||9292}"
        puts "Running command: #{cmd.colorize(:bold)}"
        puts "Rack environment: #{env.colorize(:bold)}"
        exec "env RACK_ENV=#{env} #{cmd}"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end