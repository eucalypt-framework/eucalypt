require 'eucalypt/errors'
require 'eucalypt/eucalypt-security/namespaces/security-warden/cli/security-warden'
require 'eucalypt/eucalypt-security/namespaces/security-pundit/cli/security-pundit'
require 'eucalypt/eucalypt-security/namespaces/security-policy/cli/security-policy'
require 'eucalypt/helpers'

module Eucalypt
  class Security < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    using Colorize

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
      end
    end

    register(Eucalypt::SecurityWarden, 'warden', 'warden [COMMAND]', 'Configure Warden authentication'.colorize(:grey))
    register(Eucalypt::SecurityPundit, 'pundit', 'pundit [COMMAND]', 'Configure Pundit authorization'.colorize(:grey))
    register(Eucalypt::SecurityPolicy, 'policy', 'policy [COMMAND]', 'Pundit policy commands'.colorize(:grey))
  end

  class CLI < Thor
    include Eucalypt::Helpers
    using Colorize
    register(Security, 'security', 'security [COMMAND]', 'Manage authentication and authorization'.colorize(:grey))
  end
end