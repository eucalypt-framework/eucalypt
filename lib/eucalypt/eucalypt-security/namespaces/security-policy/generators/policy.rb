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
        name = name.to_s.singularize
        file_name = name.downcase.include?('policy') ? "#{name.underscore}.rb" : "#{name.underscore}_policy.rb"
        file_path = File.join 'app', 'policies', file_name
        class_name = name.downcase.include?('policy') ? name.camelize : "#{name.camelize}Policy"
        policy = file_name.split("_policy.rb").first

        config = {class_name: class_name, policy: policy, constant: class_name.gsub('Policy','')}
        template('policy.tt', file_path, config)
      end

      def generate_policy_roles_migration(policy:)
        sleep 1
        migration = Migration[title: "create_#{policy}_roles", template: 'create_policy_roles_migration.tt']
        return unless migration.create_anyway? if migration.exists?
        config = {migration_title: migration.title.camelize, policy: policy}
        template migration.template, migration.file_path, config
      end

      def generate_policy_addition_migration(policy:, policy_name:)
        sleep 1
        migration = Migration[title: "add_#{policy}_to_roles", template: 'add_policy_to_roles_migration.tt']
        return unless migration.create_anyway? if migration.exists?
        config = {migration_title: migration.title.camelize, policy_name: policy_name}
        template migration.template, migration.file_path, config
      end
    end
  end
end
