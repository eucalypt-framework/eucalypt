require 'eucalypt/migration/namespaces/migration-drop/generators/table'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class MigrationDrop < Thor
    include Eucalypt::Helpers
    using Colorize
    desc "table [NAME]", "Removes a table".colorize(:grey)
    def table(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Drop::Table.new
        migration.destination_root = directory
        migration.generate(name: name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end