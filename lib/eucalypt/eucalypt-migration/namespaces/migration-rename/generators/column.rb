require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'

module Eucalypt
  module Generators
    module Rename
      class Column < Thor::Group
        include Thor::Actions
        include Eucalypt::Helpers
        using String::Builder

        def self.source_root
          File.join File.dirname(File.dirname(File.dirname __dir__))
        end

        def generate(table:, old_name:, new_name:)
          table = Inflect.resource_keep_inflection(table.to_s)
          old_name = Inflect.resource_keep_inflection(old_name.to_s)
          new_name = Inflect.resource_keep_inflection(new_name.to_s)

          sleep 1
          migration_name = "rename_#{old_name}_column_to_#{new_name}_on_#{table}"
          migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
          return unless migration.create_anyway? if migration.exists?
          config = {migration_class_name: migration_name.camelize}
          template 'migration_base.tt', migration.file_path, config

          insert_into_file migration.file_path, :after => "def change\n" do
            String.build do |s|
              s << "    rename_column :#{table}, :#{old_name}, :#{new_name}\n"
            end
          end
        end
      end
    end
  end
end
