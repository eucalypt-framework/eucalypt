require 'eucalypt/eucalypt-migration/namespaces/migration-remove/generators/index'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRemove < Thor
    option :name, aliases: '-n', type: :string, desc: "Index name"
    desc "index [TABLE] [*COLUMNS]", "Removes an index".colorize(:grey)
    def index(table, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Remove::Index.new
        migration.destination_root = directory
        migration.generate(table: table, columns: columns, name: options[:name])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end