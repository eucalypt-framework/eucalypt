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
    desc "generate [NAME]", "Create a new Pundit policy".colorize(:grey)
    def generate(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        # Check for authorization gems
        return unless gemfile_check(%w[pundit], 'eucalypt security pundit setup', directory)

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

        policy = Inflect.new(:policy, name)

        policy_generator = Eucalypt::Generators::Policy.new
        policy_generator.destination_root = directory

        # Generate policy file
        policy_generator.generate(name: name)

        # Create policy roles table
        policy_generator.generate_policy_roles_migration(policy: policy.resource)

        # Create policy role model
        Dir.chdir(directory) do
          Eucalypt::CLI.start(['generate', 'model', "#{policy.resource}_role", '--no-spec', '--no-table'])
        end

        # Add validation to role model
        role_model_file = File.join directory, 'app', 'models', "#{policy.resource}_role.rb"
        File.open(role_model_file) do |f|
          insert = "  validates :permission, uniqueness: true"
          inject_into_class(role_model_file, "#{policy.resource}_role".camelize, "#{insert}\n") unless f.read.include? insert
        end

        # Add policy column to user roles table
        Dir.chdir(directory) do
          args = %w[migration add column]
          args << 'roles'
          args << policy.resource
          args << 'string'
          args << %w[-o default:default]
          args.flatten!
          Eucalypt::CLI.start(args)
        end

        # Generate permissions
        options[:permissions].each do |permission|
          Eucalypt::CLI.start(['security', 'policy', 'permission', 'generate', policy.resource, permission])
        end
      else
        Eucalypt::Error.wrong_directory
      end
    end

    #def destroy()
    #end

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
      end
    end

    register(Eucalypt::SecurityPolicyPermission, 'permission', 'permission [COMMAND]', 'Pundit policy permission commands'.colorize(:grey))
    register(Eucalypt::SecurityPolicyRole, 'role', 'role [COMMAND]', 'Pundit policy role commands'.colorize(:grey))
  end
end