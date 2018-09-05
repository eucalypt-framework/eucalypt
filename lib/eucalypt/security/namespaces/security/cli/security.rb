require 'eucalypt/errors'
require 'eucalypt/security/namespaces/security-warden/cli/security-warden'
require 'eucalypt/security/namespaces/security-pundit/cli/security-pundit'
require 'eucalypt/security/namespaces/security-policy/cli/security-policy'
require 'eucalypt/helpers'
require 'eucalypt/list'

module Eucalypt
  class Security < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    using Colorize
    extend Eucalypt::List

    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
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