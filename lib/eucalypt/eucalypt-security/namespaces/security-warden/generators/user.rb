require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'
require 'active_record'

module Eucalypt
  module Generators
    class User < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers
      include Eucalypt::Helpers::Messages

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate_migration
        sleep 1
        migration = Eucalypt::Helpers::Migration[title: 'create_users', template: 'create_users_table_migration.tt']
        return unless migration.create_anyway? if migration.exists?
        template migration.template, migration.file_path
      end

      def generate_model(directory)
        model_file = File.join(directory, 'app', 'models', 'user.rb')
        Out.warning 'User model already exists.' if File.file? model_file

        Dir.chdir(directory) do
          Eucalypt::CLI.start(%w[generate model user --no-table])
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

              include BCrypt

              def authenticate(attempt)
                Password.new(self.encrypted_password) == attempt
              end

              def password=(entered_password)
                @password = Password.create(entered_password)
                self.encrypted_password = @password
              end

              def with_confirm(*fields)
                return if fields.empty?
                fields.map(&:to_sym).each {|field| instance_variable_set "@with_confirm_\#{field}", true }
                class_eval do
                  attr_accessor *fields.map {|field| "\#{field}_confirmation".to_sym }
                  attr_reader *fields.map {|field| field.to_sym }.reject {|field| field != :password}
                end

                fields.each do |field|
                  confirm = "confirm_\#{field}".to_sym
                  define_singleton_method confirm do
                    if instance_variable_get "@with_\#{confirm}"
                      case field
                      when :password
                        return if @password.nil?
                        unless authenticate @password_confirmation
                          errors.add :password_confirmation, "Passwords don't match"
                        end
                      else
                        actual = self.send field
                        return if actual.nil?
                        confirmation = instance_variable_get "@\#{field}_confirmation"
                        unless actual == confirmation
                          errors.add "\#{field}_confirmation", "\#{field.to_s.pluralize.capitalize} don't match"
                        end
                      end
                    end
                  end

                  class_eval do
                    private confirm
                    validate confirm
                  end
                end
                self
              end
          END
        )
      end
    end
  end
end
