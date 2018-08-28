require 'eucalypt/migration/namespaces/migration-rename/generators/index'
require 'eucalypt/helpers'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRename < Thor
    include Eucalypt::Helpers
    using Colorize

    desc "index [TABLE] [OLD] [NEW]", "Renames an index".colorize(:grey)
    def index(table, old_name, new_name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Rename::Index.new
        migration.destination_root = directory
        migration.generate(table: table, old_name: old_name, new_name: new_name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end