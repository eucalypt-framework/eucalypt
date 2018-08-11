require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-security/helpers'
require 'eucalypt/eucalypt-security/namespaces/security-pundit/generators/role'

module Eucalypt
  class SecurityPundit < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    include Eucalypt::Helpers::Gemfile
    include Eucalypt::Security::Helpers
    using Colorize

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

        # Add has_one to User model
        File.open(user_model_file) do |f|
          contents = f.read
          insert = "  has_one :role, dependent: :destroy"
          inject_into_class(user_model_file, 'User', "#{insert}\n") unless contents.include? insert
          insert = "  after_save :create_role"
          inject_into_class(user_model_file, 'User', "#{insert}\n") unless contents.include? insert
          insert = "\n  def create_role() self.role = Role.new end\n"
          inject_into_file(user_model_file, insert, before: /^end/) unless contents.include? insert
        end

        Out.info "Ensure you run `#{'rake db:migrate'.colorize(:bold)}` to create the necessary tables for Pundit."
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