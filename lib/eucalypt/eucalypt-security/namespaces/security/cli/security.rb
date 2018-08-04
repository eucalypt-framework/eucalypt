require 'eucalypt/errors'
require 'eucalypt/eucalypt-security/namespaces/security-warden/cli/security-warden'
require 'eucalypt/eucalypt-security/namespaces/security-pundit/cli/security-pundit'
require 'eucalypt/eucalypt-security/namespaces/security-policy/cli/security-policy'

module Eucalypt
  class Security < Thor
    include Thor::Actions

    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
    end

    register(Eucalypt::SecurityWarden, 'warden', 'warden [COMMAND]', 'Configure Warden authentication')
    register(Eucalypt::SecurityPundit, 'pundit', 'pundit [COMMAND]', 'Configure Pundit authorization')
    register(Eucalypt::SecurityPolicy, 'policy', 'policy [COMMAND]', 'Pundit policy commands')
  end

  class CLI < Thor
    register(Security, 'security', 'security [COMMAND]', 'Manage authentication and authorization')
  end
end