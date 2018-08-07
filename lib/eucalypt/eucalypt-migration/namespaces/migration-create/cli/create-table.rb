require 'eucalypt/eucalypt-migration/namespaces/migration-create/generators/table'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationCreate < Thor
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Table options"
    desc "table [NAME] *[COLUMN∶TYPE]", "Creates a table".colorize(:grey)
    def table(name, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Create::Table.new
        migration.destination_root = directory
        migration.generate(name: name, columns: columns, options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end