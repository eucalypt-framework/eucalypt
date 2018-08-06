require 'eucalypt/eucalypt-migration/namespaces/migration-create/generators/index'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationCreate < Thor
    option :name, aliases: '-n', type: :string, desc: "Index name"
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Index options"
    desc "index [TABLE] *[COLUMNS]", "Creates an index".colorize(:grey)
    def index(table, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Create::Index.new
        migration.destination_root = directory
        migration.generate(table: table, columns: columns, name: options[:name], options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end