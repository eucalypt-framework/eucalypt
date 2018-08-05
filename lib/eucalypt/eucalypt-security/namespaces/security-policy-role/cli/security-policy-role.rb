require 'thor'
require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-security/namespaces/security-policy-role/generators/policy-role'

module Eucalypt
  class SecurityPolicyRole < Thor
    include Thor::Actions
    include Eucalypt::Helpers

    desc "generate", "Create a new Pundit policy role"
    def generate(name, role)
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

        # Check for policy file and policy role model
        policy_file = File.join(directory, 'app', 'policies', "#{policy_name}_policy.rb")
        policy_role_model = File.join(directory, 'app', 'models', "#{policy_name}_role.rb")
        unless File.exist?(policy_file) && File.exist?(policy_role_model)
          Eucalypt::Error.no_policy(policy_name)
          return
        end

        policy_role = Eucalypt::Generators::PolicyRole.new
        policy_role.destination_root = directory

        # Add role to policy
        policy_role.generate(policy_name: policy_name, role: role.underscore)
      else
        Eucalypt::Error.wrong_directory
      end
    end

    # def destroy()
    # end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security policy #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end