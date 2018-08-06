require 'eucalypt/eucalypt-migration/namespaces/migration-create/cli/create'
require 'eucalypt/eucalypt-migration/namespaces/migration-remove/cli/remove'

module Eucalypt
  class Migration < Thor
    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
    end

    register(Eucalypt::MigrationCreate, 'create', 'create [COMMAND]', 'Generate creation migrations')
    register(Eucalypt::MigrationRemove, 'remove', 'remove [COMMAND]', 'Generate removal migrations')
  end
  class CLI < Thor
    register(Migration, 'migration', 'migration [COMMAND]', 'Generate database/model migrations')
  end
end