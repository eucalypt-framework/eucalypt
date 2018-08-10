require 'eucalypt/eucalypt-migration/namespaces/migration-add/generators/index'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class MigrationAdd < Thor
    option :name, aliases: '-n', type: :string, default: 'index', desc: "Index name"
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Index options"
    desc "index [TABLE] *[COLUMNS]", "Adds an index".colorize(:grey)
    def index(table, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Add::Index.new
        migration.destination_root = directory
        migration.generate(table: table, columns: columns, name: options[:name], options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end