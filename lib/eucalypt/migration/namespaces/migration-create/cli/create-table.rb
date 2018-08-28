require 'eucalypt/migration/namespaces/migration-create/generators/table'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class MigrationCreate < Thor
    include Eucalypt::Helpers
    using Colorize
    option :options, aliases: '-o', type: :hash, default: {}, enum: %w[primary_key id temporary force], desc: "Table options"
    desc "table [NAME] *[COLUMN∶TYPE]", "Creates a table".colorize(:grey)
    def table(name, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        validation = Eucalypt::Helpers::Migration::Validation.new columns
        return if validation.any_invalid?
        migration = Eucalypt::Generators::Create::Table.new
        migration.destination_root = directory
        migration.generate(name: name, columns: columns, options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end