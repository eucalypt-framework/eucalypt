require 'thor'
require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-security/namespaces/security-policy/generators/policy'
require 'eucalypt/eucalypt-security/namespaces/security-policy-permission/cli/security-policy-permission'
require 'eucalypt/eucalypt-security/namespaces/security-policy-role/cli/security-policy-role'

module Eucalypt
  class SecurityPolicy < Thor
    include Thor::Actions
    include Eucalypt::Helpers

    method_option :permissions, type: :array, aliases: '-p', default: []
    desc "generate", "Create a new Pundit policy"
    def generate(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        # Check for authorization gems
        return unless gem_check(%w[pundit], 'eucalypt security pundit setup', directory)

        # Check for user model
        unless File.exist? File.join(directory, 'app', 'models', 'user.rb')
          Eucalypt::Error.no_user_model
          return
        end

        # Check for role model
        unless File.exist? File.join(directory, 'app', 'models', 'role.rb')
          Eucalypt::Error.no_role_model
          return
        end

        policy_name = name.singularize.underscore.gsub(/\_policy$/,'')

        policy = Eucalypt::Generators::Policy.new
        policy.destination_root = directory

        # Generate policy file
        policy.generate(name: name)

        # Create policy roles table
        policy.generate_policy_roles_migration(policy: policy_name)

        # Create policy role model
        Dir.chdir(directory) do
          Eucalypt::CLI.start(['generate', 'model', "#{policy_name}_role", '--no-spec'])
        end

        # Add validation to role model
        role_model_file = File.join directory, 'app', 'models', "#{policy_name}_role.rb"
        File.open(role_model_file) do |f|
          insert = "  validates :permission, uniqueness: true"
          inject_into_class(role_model_file, "#{policy_name}_role".camelize, "#{insert}\n") unless f.read.include? insert
        end

        # Add policy column to role model
        policy.generate_policy_addition_migration(policy: name, policy_name: policy_name)

        # Generate permissions
        options[:permissions].each do |permission|
          Eucalypt::CLI.start(['security', 'policy', 'permission', 'generate', policy_name, permission])
        end
      else
        Eucalypt::Error.wrong_directory
      end
    end

    #def destroy()
    #end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end

    register(Eucalypt::SecurityPolicyPermission, 'permission', 'permission [COMMAND]', 'Pundit policy permission commands')
    register(Eucalypt::SecurityPolicyRole, 'role', 'role [COMMAND]', 'Pundit policy role commands')
  end
end