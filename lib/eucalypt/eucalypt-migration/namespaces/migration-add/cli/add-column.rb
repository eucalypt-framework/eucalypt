require 'eucalypt/eucalypt-migration/namespaces/migration-add/generators/column'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class MigrationAdd < Thor
    include Eucalypt::Helpers
    using Colorize

    option :options, aliases: '-o', type: :hash, default: {}, enum: %w[limit default null precision scale], desc: "Column options"
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