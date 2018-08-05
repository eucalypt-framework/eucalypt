require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class PolicyRole < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(policy_name:, role:)
        sleep 1
        migration = Migration[
          title: "add_#{role}_role_to_#{policy_name}_policy",
          template: 'add_role_to_policy_migration.tt'
        ]
        return unless migration.create_anyway? if migration.exists?
        config = {migration_title: migration.title.camelize, policy_name: policy_name, role: role}
        template migration.template, migration.file_path, config
      end
    end
  end
end