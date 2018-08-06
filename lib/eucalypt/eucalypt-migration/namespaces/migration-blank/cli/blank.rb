require 'eucalypt/eucalypt-migration/namespaces/migration-blank/generators/blank'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class Migration < Thor
    desc "blank [NAME]", "Creates a blank migration".colorize(:grey)
    def blank(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Blank.new
        migration.destination_root = directory
        migration.generate(name: name)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end