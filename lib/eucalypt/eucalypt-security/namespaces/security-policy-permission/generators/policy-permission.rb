require 'active_support'
require 'active_support/core_ext'
require 'thor'

module Eucalypt
  module Generators
    class PolicyPermission < Thor::Group
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(policy_name:, permission:)
        sleep 1
        migration_title = "add_#{permission}_permission_to_#{policy_name}_policy"
        migration_file = Time.now.strftime("%Y%m%d%H%M%S_#{migration_title}.rb")
        migration_base = File.join 'db', 'migrate'
        migration_file_path = File.join migration_base, migration_file

        config = {policy: policy_name.camelize, permission: permission, permission_constant: permission.camelize}
        if Dir[File.join migration_base, '*.rb'].any? {|f| f.include? migration_title}
          create_migration = ask("\e[1;93mWARNING\e[0m: A \e[1m#{migration_title}\e[0m migration already exists. Create anyway?", limited_to: %w[y Y Yes YES n N No NO])
          return unless %w[y Y Yes YES].include? create_migration
          template 'add_permission_to_policy_migration.tt', migration_file_path, config
        else
          template 'add_permission_to_policy_migration.tt', migration_file_path, config
        end
      end
    end
  end
end