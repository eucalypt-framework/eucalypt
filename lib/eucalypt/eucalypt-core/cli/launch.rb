require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    include Eucalypt::Helpers::Messages
    method_option :port, type: :numeric, aliases: '-p', desc: 'Port to serve the application on'
    method_option :rerun, type: :boolean, aliases: '-r', desc: 'Rerun (watch for file changes and restart server)'
    method_option :quiet, type: :boolean, aliases: '-q', desc: 'Silences rerun (runs less verbosely)'
    desc "launch [ENV]", "Launches your application".colorize(:grey)
    def launch(env = ENV['RACK_ENV']||'development')
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        unless %w[production development test].include? env
          Out.error "Invalid Rack environment #{env.colorize(:bold)}"
          return
        end

        cmd = "bundle exec rackup -p #{options[:port]||9292}"

        if options[:rerun]
          cmd = "rerun \"#{cmd}\""
          cmd.gsub!('rerun', 'rerun -q') if options[:quiet]
        end

        puts "Running command: #{cmd.colorize(:bold)}"
        puts "Rack environment: #{env.colorize(:bold)}"
        exec "env RACK_ENV=#{env} #{cmd}"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end