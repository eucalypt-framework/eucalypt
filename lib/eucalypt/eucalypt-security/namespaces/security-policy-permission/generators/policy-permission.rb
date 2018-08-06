require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class PolicyPermission < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(policy_name:, permission:)
        sleep 1
        migration = Eucalypt::Helpers::Migration[
          title: "add_#{permission}_permission_to_#{policy_name}_policy",
          template: 'add_permission_to_policy_migration.tt'
        ]
        return unless migration.create_anyway? if migration.exists?
        config = {migration_title: migration.title.camelize, policy_name: policy_name, permission: permission}
        template migration.template, migration.file_path, config
      end
    end
  end
end