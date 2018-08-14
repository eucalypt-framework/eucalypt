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

        if File.file? model_file
          Out.warning 'User model already exists.'
          return
        end

        template 'user.tt', model_file
      end
    end
  end
end
