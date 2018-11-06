require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/security/helpers'
require 'eucalypt/security/namespaces/security-pundit/generators/role'
require 'eucalypt/list'

module Eucalypt
  class SecurityPundit < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    include Eucalypt::Helpers::Gemfile
    include Eucalypt::Security::Helpers
    using Colorize
    extend Eucalypt::List

    def self.source_root
      File.join File.dirname(__dir__), 'templates'
    end

    desc "setup", "Set up Pundit authorization".colorize(:grey)
    def setup
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        # Check if user model exists
        user_model_file = File.join(directory, 'app', 'models', 'user.rb')
        unless File.file? user_model_file
          Eucalypt::Error.no_user_model
          return
        end

        Out.setup "Setting up Pundit authorization..."

        # Add Pundit to Gemfile
        gemfile_add('Authorization', {pundit: '~> 2.0'}, directory)

        # Create Pundit config file
        create_config_file(:pundit, directory)

        # Create roles migration
        Eucalypt::Generators::Role.new.generate_roles_migration

        # Create Role model
        role_model_file = File.join(directory, 'app', 'models', 'role.rb')
        Out.warning "Role model already exists." if File.file? role_model_file
        Dir.chdir(directory) do
          Eucalypt::CLI.start(%w[generate model role --no-spec --no-table])
        end

        # Add belongs_to to Role model
        File.open(role_model_file) do |f|
          insert = "  belongs_to :user"
          inject_into_class(role_model_file, 'Role', "#{insert}\n") unless f.read.include? insert
        end

        # Add relationship to User model
        File.open(user_model_file) do |f|
          contents = f.read
          insert = "  has_one :role, dependent: :destroy\n"
          inject_into_file(user_model_file, insert, before: /  include BCrypt/) unless contents.include? insert
          insert = "  after_save :create_role\n\n"
          inject_into_file(user_model_file, insert, before: /  include BCrypt/) unless contents.include? insert
          insert = "\n  private\n\n  def create_role\n    self.role = Role.new\n  end\n"
          inject_into_file(user_model_file, insert, before: /^end/) unless contents.include? insert
        end

        Out.info "Ensure you run `#{'eucalypt rake'.colorize(:bold)}` to create the necessary tables for Pundit."
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end