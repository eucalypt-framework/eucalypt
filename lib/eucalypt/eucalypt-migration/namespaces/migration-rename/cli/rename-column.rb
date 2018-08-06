require 'eucalypt/eucalypt-migration/namespaces/migration-rename/generators/column'
require 'eucalypt/helpers'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRename < Thor
    include Eucalypt::Helpers

    desc "column [TABLE] [OLD] [NEW]", "Renames a column".colorize(:grey)
    def column(table, old_name, new_name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Rename::Column.new
        migration.destination_root = directory
        migration.generate(table: table, old_name: old_name, new_name: new_name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end