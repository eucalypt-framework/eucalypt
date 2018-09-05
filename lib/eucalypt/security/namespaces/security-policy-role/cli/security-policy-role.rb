require 'thor'
require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/list'

module Eucalypt
  class SecurityPolicyRole < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    using Colorize
    extend Eucalypt::List

    desc "generate [POLICY] [ROLE]", "Create a new Pundit policy role".colorize(:grey)
    def generate(name, role)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        # Check for authorization gems
        return unless Gemfile.check(%w[pundit], 'eucalypt security pundit setup', directory)

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

        # Check for policy file and policy role model
        policy_file = File.join(directory, 'app', 'policies', policy.file_name)
        policy_role_model = File.join(directory, 'app', 'models', "#{policy.resource}_role.rb")
        unless File.exist?(policy_file) && File.exist?(policy_role_model)
          Eucalypt::Error.no_policy(policy.resource)
          return
        end

        # Add role column to policy roles table
        Dir.chdir(directory) do
          args = %w[migration add column]
          args << "#{policy.resource}_roles"
          args << Inflect.resource(role)
          args << 'boolean'
          args << %w[-o default:false]
          args.flatten!
          Eucalypt::CLI.start(args)
        end
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