require 'eucalypt/eucalypt-migration/namespaces/migration-drop/generators/column'
require 'eucalypt/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationDrop < Thor
    desc "column [TABLE] [NAME]", "Removes a column from a table".colorize(:grey)
    def column(table, name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Drop::Column.new
        migration.destination_root = directory
        migration.generate(table: table, name: name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end