require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'

module Eucalypt
  module Generators
    class Blank < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers
      using String::Builder

      def self.source_root
        File.join File.dirname(File.dirname(File.dirname __dir__))
      end

      def generate(name:)
        migration_name = Inflect.resource_keep_inflection(name.to_s)

        sleep 1
        migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
        return unless migration.create_anyway? if migration.exists?
        config = {migration_class_name: migration_name.camelize}
        template 'migration_base.tt', migration.file_path, config
      end
    end
  end
end