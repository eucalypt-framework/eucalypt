require 'thor'
require 'eucalypt/eucalypt-security/helpers'
module Eucalypt
  class SecurityPundit < Thor
    include Thor::Actions
    include Eucalypt::Security::Helpers

    def self.source_root
      File.join File.dirname(__dir__), 'templates'
    end

    desc "setup", "Set up Pundit authorization"
    def setup
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        # Check if user model exists
        user_model_file = File.join(directory, 'app', 'models', 'user.rb')
        unless File.file? user_model_file
          Eucalypt::Error.no_user_model
          return
        end

        puts "\n\e[94;4mSetting up Pundit authorization...\e[0m"

        # Add Pundit to Gemfile
        add_to_gemfile('Authorization', {pundit: '~> 2.0'}, directory)
        # Create Pundit config file
        create_config_file(:pundit, directory)

        # Create user_roles migration
        sleep 1
        migration_file = Time.now.strftime("%Y%m%d%H%M%S_create_roles.rb")
        migration_base = File.join directory, 'db', 'migrate'
        migration_file_path = File.join migration_base, migration_file
        if Dir[File.join migration_base, '*.rb'].any? {|f| f.include? 'create_roles'}
          create_migration = ask("\e[1;93mWARNING\e[0m: A \e[1mcreate_roles\e[0m migration already exists. Create anyway?", limited_to: %w[y Y Yes YES n N No NO])
          return unless %w[y Y Yes YES].include? create_migration
          template 'create_roles_migration.tt', migration_file_path
        else
          template 'create_roles_migration.tt', migration_file_path
        end

        # Create Role model
        role_model_file = File.join(directory, 'app', 'models', 'role.rb')
        puts "\e[1;93mWARNING\e[0m: Role model already exists." if File.file? role_model_file
        Dir.chdir(directory) do
          Eucalypt::CLI.start(%w[generate model role --no-spec])
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
          inject_into_file(user_model_file, insert, before: /^end/)
        end

        puts "\e[1mINFO\e[0m: Ensure you run `\e[1mrake db:migrate\e[0m` to create the necessary tables for Pundit."
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end