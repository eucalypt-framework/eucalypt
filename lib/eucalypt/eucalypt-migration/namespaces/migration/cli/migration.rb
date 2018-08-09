require 'eucalypt/eucalypt-migration/namespaces/migration-create/cli/create'
require 'eucalypt/eucalypt-migration/namespaces/migration-add/cli/add'
require 'eucalypt/eucalypt-migration/namespaces/migration-drop/cli/drop'
require 'eucalypt/eucalypt-migration/namespaces/migration-rename/cli/rename'
require 'eucalypt/eucalypt-migration/namespaces/migration-change/cli/change'
require 'eucalypt/eucalypt-migration/namespaces/migration-blank/cli/blank'
require 'eucalypt/helpers/migration'

module Eucalypt
  class Migration < Thor
    include Thor::Actions
    include Eucalypt::Helpers

    desc "types", "Display permitted column types".colorize(:grey)
    def types
      puts Eucalypt::Helpers::Migration::Validation::COLUMN_TYPES.inspect
    end

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
      end
    end

    register(Eucalypt::MigrationCreate, 'create', 'create [COMMAND]', 'Create tables'.colorize(:grey))
    register(Eucalypt::MigrationAdd, 'add', 'add [COMMAND]', 'Add indexes and columns to a table'.colorize(:grey))
    register(Eucalypt::MigrationDrop, 'drop', 'drop [COMMAND]', 'Drop tables, columns and indexes'.colorize(:grey))
    register(Eucalypt::MigrationRename, 'rename', 'rename [COMMAND]', 'Rename tables, columns and indexes'.colorize(:grey))
    register(Eucalypt::MigrationChange, 'change', 'change [COMMAND]', 'Change column definitions'.colorize(:grey))
  end
  class CLI < Thor
    register(Migration, 'migration', 'migration [COMMAND]', 'Generate ActiveRecord migrations'.colorize(:grey))
  end
end