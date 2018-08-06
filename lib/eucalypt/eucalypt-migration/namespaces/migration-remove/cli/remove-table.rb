require 'eucalypt/eucalypt-migration/namespaces/migration-remove/generators/table'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRemove < Thor
    desc "table [NAME]", "Removes a table"
    def table(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Remove::Table.new
        migration.destination_root = directory
        migration.generate(name: name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end