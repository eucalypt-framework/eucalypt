require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    desc "console [ENV]", "Interactive console with all files loaded".colorize(:grey)
    def console(env = ENV['APP_ENV']||'development')
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        unless %w[p production d development t test].include? env
          Out.error "Invalid Rack environment #{env.colorize(:bold)}"
          return
        end

        env = map_env env
        cmd = "CONSOLE=true bundle exec irb -r ./app.rb"

        puts "Running command: #{cmd.colorize(:bold)}"
        puts "Rack environment: #{env.colorize(:bold)}"
        exec "env APP_ENV=#{env} #{cmd}"
      else
        Eucalypt::Error.wrong_directory
      end
    end

    no_tasks do
      def map_env(env)
        case env
        when ?p then 'production'
        when ?d then 'development'
        when ?t then 'test'
        else env
        end
      end
    end
  end
end