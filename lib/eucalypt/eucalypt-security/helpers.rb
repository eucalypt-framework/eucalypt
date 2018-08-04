require 'active_support/core_ext'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-generate/namespaces/generate/cli/generate'
module Eucalypt
  class Security < Thor
    module Helpers
      include Eucalypt::Helpers

      def create_config_file(type, directory)
        config_file = File.join(directory, 'config', 'sinatra', "#{type}.rb")
        if File.file? config_file
          puts "\e[1;93mWARNING\e[0m: #{type.to_s.capitalize} config file \e[1mconfig/sinatra/#{type}.rb\e[0m already exists."
        end
        template "#{type}.tt", config_file
      end

      def create_users_migration_file(directory)
        migration_file = Time.now.strftime("%Y%m%d%H%M%S_create_users.rb")
        migration_base = File.join directory, 'db', 'migrate'
        migration_file_path = File.join migration_base, migration_file
        if Dir[File.join migration_base, '*.rb'].any? {|f| f.include? 'create_users'}
          create_migration = ask("\e[1;93mWARNING\e[0m: A \e[1mcreate_users\e[0m migration already exists. Create anyway?", limited_to: %w[y Y Yes YES n N No NO])
          return unless %w[y Y Yes YES].include? create_migration
          template 'create_users_table_migration.tt', migration_file_path
        else
          template 'create_users_table_migration.tt', migration_file_path
        end
      end

      def create_user_model(directory)
        model_file = File.join(directory, 'app', 'models', 'user.rb')

        puts "\e[1;93mWARNING\e[0m: User model already exists." if File.file? model_file

        Dir.chdir(directory) do
          Eucalypt::CLI.start(%w[generate model user])
        end

        File.open(model_file) do |f|
          return unless f.read.include? "# Add your model methods here..."
        end

        gsub_file(
          model_file,
          "# Add your model methods here...\n",
          <<~END
            validates :username, presence: true, uniqueness: true
              validates :encrypted_password, presence: true
              validate :confirm_password

              attr_reader :password
              attr_accessor :password_confirmation

              include BCrypt

              def authenticate(attempt)
                Password.new(self.encrypted_password) == attempt
              end

              def password=(entered_password)
                @password = Password.create(entered_password)
                self.encrypted_password = @password
              end

              def with_confirm_password
                @with_confirm_password = true
                self
              end

              private

              def confirm_password
                if @with_confirm_password
                  return if @password.nil?
                  unless authenticate(@password_confirmation)
                    errors.add :password_confirmation, "Passwords don't match"
                  end
                end
              end
          END
        )
      end
    end
  end
end