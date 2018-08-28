require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'
require 'eucalypt/migration/helpers'

module Eucalypt
  module Generators
    module Change
      class Column < Thor::Group
        include Thor::Actions
        include Eucalypt::Helpers
        include Eucalypt::Migration::Helpers
        using String::Builder

        def self.source_root
          File.join File.dirname(File.dirname(File.dirname __dir__))
        end

        def generate(table:, column:, type:, options: {})
          table = Inflect.resource_keep_inflection(table.to_s)
          column = Inflect.resource_keep_inflection(column.to_s)
          type = Inflect.resource_keep_inflection(type.to_s)

          sleep 1
          migration_name = "change_#{column}_column_on_#{table}"
          migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
          return unless migration.create_anyway? if migration.exists?
          config = {migration_class_name: migration_name.camelize}
          template migration.template, migration.file_path, config

          sanitized_options = sanitize_column_options(options)

          insert_into_file migration.file_path, :after => "def change\n" do
            String.build do |s|
              s << "    change_column :#{table}, :#{column}, :#{type}"
              s << ', ' unless sanitized_options.empty?
              s << sanitized_options.map{|opt| "#{opt.first}: #{opt.last}"}*', '
              s << "\n"
            end
          end
        end
      end
    end
  end
end
