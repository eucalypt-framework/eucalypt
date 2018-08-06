require 'eucalypt/eucalypt-migration/namespaces/migration-remove/generators/column'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRemove < Thor
    desc "column [TABLE] [NAME]", "Removes a column"
    def column(table, name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Remove::Column.new
        migration.destination_root = directory
        migration.generate(table: table, name: name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end