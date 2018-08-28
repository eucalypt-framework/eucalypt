require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class Role < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate_roles_migration
        sleep 1
        migration = Eucalypt::Helpers::Migration[title: "create_roles", template: 'create_roles_migration.tt']
        return unless migration.create_anyway? if migration.exists?
        template migration.template, migration.file_path
      end
    end
  end
end
