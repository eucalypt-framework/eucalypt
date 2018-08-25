require 'eucalypt/eucalypt-migration/namespaces/migration-drop/generators/index'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class MigrationDrop < Thor
    include Eucalypt::Helpers
    using Colorize
    option :name, aliases: '-n', type: :string, desc: "Index name"
    desc "index [TABLE] *[COLUMNS]", "Removes an index from a table".colorize(:grey)
    def index(table, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Drop::Index.new
        migration.destination_root = directory
        migration.generate(table: table, columns: columns, name: options[:name]||'index')
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end