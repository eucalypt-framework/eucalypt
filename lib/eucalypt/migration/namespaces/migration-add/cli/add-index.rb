require 'eucalypt/migration/namespaces/migration-add/generators/index'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class MigrationAdd < Thor
    include Eucalypt::Helpers
    using Colorize

    option :name, aliases: '-n', type: :string, desc: "Index name"
    option :options, aliases: '-o', type: :hash, default: {}, enum: %w[unique length where using type], desc: "Index options"
    desc "index [TABLE] *[COLUMNS]", "Adds an index".colorize(:grey)
    def index(table, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Add::Index.new
        migration.destination_root = directory
        migration.generate(table: table, columns: columns, name: options[:name]||'index', options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end