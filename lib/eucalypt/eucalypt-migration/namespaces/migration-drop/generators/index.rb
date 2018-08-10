require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'

module Eucalypt
  module Generators
    module Drop
      class Index < Thor::Group
        include Thor::Actions
        include Eucalypt::Helpers
        using String::Builder

        def self.source_root
          File.join File.dirname(File.dirname(File.dirname __dir__))
        end

        def generate(table:, columns: [], name: 'index')
          table = Inflect.resource_keep_inflection(table.to_s)
          name = Inflect.resource_keep_inflection(name.to_s)

          sleep 1
          migration_name = "drop_#{name}_from_#{table}"
          migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
          return unless migration.create_anyway? if migration.exists?
          config = {migration_class_name: migration_name.camelize}
          template migration.template, migration.file_path, config

          insert_into_file migration.file_path, :after => "def change\n" do
            String.build do |s|
              s << "    remove_index :#{table}"
              unless name.empty?
                s << ", name: :#{name}"
              else
                unless columns.empty?
                  columns.map!(&:to_sym)
                  s << ", column: "
                  s << (columns.size == 1 ? ":#{columns.first}" : "#{columns.inspect}")
                end
              end
              s << "\n"
            end
          end
        end
      end
    end
  end
end
