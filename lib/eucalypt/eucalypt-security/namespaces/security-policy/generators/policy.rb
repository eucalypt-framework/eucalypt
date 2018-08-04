require 'active_support'
require 'active_support/core_ext'
require 'thor'

module Eucalypt
  module Generators
    class Policy < Thor::Group
      include Thor::Actions

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
        migration_file = Time.now.strftime("%Y%m%d%H%M%S_create_#{policy}_roles.rb")
        migration_base = File.join 'db', 'migrate'
        migration_file_path = File.join migration_base, migration_file
        config = {policy: policy}
        if Dir[File.join migration_base, '*.rb'].any? {|f| f.include? "create_#{policy}_roles"}
          create_migration = ask("\e[1;93mWARNING\e[0m: A \e[1mcreate_#{policy}_roles\e[0m migration already exists. Create anyway?", limited_to: %w[y Y Yes YES n N No NO])
          return unless %w[y Y Yes YES].include? create_migration
          template 'create_policy_roles_migration.tt', migration_file_path, config
        else
          template 'create_policy_roles_migration.tt', migration_file_path, config
        end
      end

      def generate_policy_addition_migration(policy:, policy_name:)
        sleep 1
        migration_file = Time.now.strftime("%Y%m%d%H%M%S_add_#{policy}_to_roles.rb")
        migration_base = File.join 'db', 'migrate'
        migration_file_path = File.join migration_base, migration_file
        config = {policy: policy, policy_name: policy_name}
        if Dir[File.join migration_base, '*.rb'].any? {|f| f.include? "add_#{policy}_to_roles"}
          create_migration = ask("\e[1;93mWARNING\e[0m: A \e[1madd_#{policy}_to_roles\e[0m migration already exists. Create anyway?", limited_to: %w[y Y Yes YES n N No NO])
          return unless %w[y Y Yes YES].include? create_migration
          template 'add_policy_to_roles_migration.tt', migration_file_path, config
        else
          template 'add_policy_to_roles_migration.tt', migration_file_path, config
        end
      end

    end
  end
end
