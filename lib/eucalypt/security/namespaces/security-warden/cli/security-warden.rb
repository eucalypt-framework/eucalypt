require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/security/helpers'
require 'eucalypt/security/namespaces/security-warden/generators/user'
require 'eucalypt/security/namespaces/security-warden/generators/auth_controller'
require 'eucalypt/list'

module Eucalypt
  class SecurityWarden < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    include Eucalypt::Helpers::Gemfile
    include Eucalypt::Security::Helpers
    using Colorize
    using String::Builder
    extend Eucalypt::List

    def self.source_root
      File.join File.dirname(__dir__), 'templates'
    end

    option :controller, type: :boolean, default: true, desc: "Include an authentication controller"
    desc "setup", "Set up Warden authentication".colorize(:grey)
    def setup
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        Out.setup "Setting up Warden authentication..."

        # Add Warden and BCrypt to Gemfile
        gemfile_add('Authentication and encryption', {warden: '~> 1.2', bcrypt: '~> 3.1'}, directory)

        # Create Warden config file
        create_config_file(:warden, directory)

        # Add middleware to config.ru
        middleware = String.build do |s|
          s << "\nuse Warden::Manager do |config|\n"
          s << "  config.serialize_into_session{|user| user.id}\n"
          s << "  config.serialize_from_session{|id| User.find(id)}\n"
          s << "  config.scope_defaults :default, strategies: [:password], action: 'auth/invalid'\n"
          s << "  config.failure_app = self\n"
          s << "end\n"
        end

        config_ru = File.join(directory, 'config.ru')

        File.open config_ru do |f|
          contents = f.read
          inject_into_file(config_ru, middleware, after: /require_relative 'app'\n/) unless contents.include? 'use Warden::Manager'
        end

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

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end