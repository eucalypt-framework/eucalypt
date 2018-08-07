require 'eucalypt/eucalypt-migration/namespaces/migration-create/cli/create'
require 'eucalypt/eucalypt-migration/namespaces/migration-remove/cli/remove'
require 'eucalypt/eucalypt-migration/namespaces/migration-rename/cli/rename'
require 'eucalypt/eucalypt-migration/namespaces/migration-change/cli/change'
require 'eucalypt/eucalypt-migration/namespaces/migration-blank/cli/blank'

module Eucalypt
  class Migration < Thor
    include Thor::Actions
    include Eucalypt::Helpers

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
      end
    end

    register(Eucalypt::MigrationCreate, 'create', 'create [COMMAND]', 'Generate creation migrations'.colorize(:grey))
    register(Eucalypt::MigrationRemove, 'remove', 'remove [COMMAND]', 'Generate removal migrations'.colorize(:grey))
    register(Eucalypt::MigrationRename, 'rename', 'rename [COMMAND]', 'Generate renaming migrations'.colorize(:grey))
    register(Eucalypt::MigrationChange, 'change', 'change [COMMAND]', 'Generate change migrations'.colorize(:grey))
  end
  class CLI < Thor
    register(Migration, 'migration', 'migration [COMMAND]', 'Generate ActiveRecord migrations'.colorize(:grey))
  end
end