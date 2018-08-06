require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class Policy < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(name:)
        policy = Inflect.new(:policy, name)
        config = {class_name: policy.class_name, resource: policy.resource, constant: policy.constant}
        template('policy.tt', policy.file_path, config)
      end

      def generate_policy_roles_migration(policy:)
        sleep 1
        migration = Eucalypt::Helpers::Migration[title: "create_#{policy}_roles", template: 'create_policy_roles_migration.tt']
        return unless migration.create_anyway? if migration.exists?
        config = {migration_title: migration.title.camelize, policy: policy}
        template migration.template, migration.file_path, config
      end
    end
  end
end
