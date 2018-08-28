require 'eucalypt/migration/namespaces/migration-rename/generators/table'
require 'eucalypt/helpers'
require 'eucalypt/errors'

module Eucalypt
  class MigrationRename < Thor
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    using Colorize

    desc "table [OLD] [NEW]", "Renames a table".colorize(:grey)
    def table(old_name, new_name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        Out.warning "This command #{"will not".colorize(:bold)} rename any associated model."
        migration = Eucalypt::Generators::Rename::Table.new
        migration.destination_root = directory
        migration.generate(old_name: old_name, new_name: new_name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end