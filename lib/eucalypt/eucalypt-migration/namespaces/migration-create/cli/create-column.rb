require 'eucalypt/eucalypt-migration/namespaces/migration-create/generators/column'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationCreate < Thor
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Column options"
    desc "column [TABLE] [COLUMN] [TYPE]", "Creates a column".colorize(:grey)
    def column(table, column, type)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Create::Column.new
        migration.destination_root = directory
        migration.generate(table: table, column: column, type: type, options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end