require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-security/helpers'
require 'eucalypt/eucalypt-security/namespaces/security-warden/generators/user'
require 'eucalypt/eucalypt-security/namespaces/security-warden/generators/auth_controller'

module Eucalypt
  class SecurityWarden < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Security::Helpers

    def self.source_root
      File.join File.dirname(__dir__), 'templates'
    end

    option :controller, type: :boolean, aliases: '-c', default: true, desc: "Include an authentication controller"
    desc "setup", "Set up Warden authentication".colorize(:grey)
    def setup
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        Out.setup "Setting up Warden authentication..."

        # Add Warden and BCrypt to Gemfile
        gemfile_add('Authentication and encryption', {warden: '~> 1.2', bcrypt: '~> 3.1'}, directory)

        # Create Warden config file
        create_config_file(:warden, directory)

        user = Eucalypt::Generators::User.new

        # Create user migration
        user.generate_migration

        # Create user model
        user.generate_model(directory)

        if options[:controller]
          auth_controller = Eucalypt::Generators::AuthController.new
          auth_controller.destination_root = directory
          auth_controller.generate
        end

        Out.info "Ensure you run `#{'rake db:migrate'.colorize(:bold)}` to create the necessary tables for Warden."
      else
        Eucalypt::Error.wrong_directory
      end
    end

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
      end
    end
  end
end