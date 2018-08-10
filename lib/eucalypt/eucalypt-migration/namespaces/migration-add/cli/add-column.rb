require 'eucalypt/eucalypt-migration/namespaces/migration-add/generators/column'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationAdd < Thor
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Column options"
    desc "column [TABLE] [COLUMN] [TYPE]", "Adds a column".colorize(:grey)
    def column(table, column, type)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        return unless Eucalypt::Helpers::Migration::Validation.valid_type? type
        migration = Eucalypt::Generators::Add::Column.new
        migration.destination_root = directory
        migration.generate(table: table, column: column, type: type, options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end