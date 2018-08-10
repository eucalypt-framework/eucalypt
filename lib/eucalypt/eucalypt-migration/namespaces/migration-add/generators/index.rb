require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'
require 'eucalypt/eucalypt-migration/helpers'

module Eucalypt
  module Generators
    module Add
      class Index < Thor::Group
        include Thor::Actions
        include Eucalypt::Helpers
        include Eucalypt::Migration::Helpers
        using String::Builder

        def self.source_root
          File.join File.dirname(File.dirname(File.dirname __dir__))
        end

        def generate(table:, columns: [], options: {}, name:)
          name = Inflect.resource_keep_inflection(name.to_s)
          table = Inflect.resource_keep_inflection(table.to_s)
          columns.map!{|i| Inflect.resource_keep_inflection(i)}

          sleep 1
          migration_name = "add_#{name}_to_#{table}"
          migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
          return unless migration.create_anyway? if migration.exists?
          config = {migration_class_name: migration_name.camelize}
          template migration.template, migration.file_path, config

          sanitized_options = sanitize_index_options(options)

          insert_into_file migration.file_path, :after => "def change\n" do
            String.build do |s|
              s << "    add_index :#{table}, "
              unless columns.empty?
                columns.map!(&:to_sym)
                s << (columns.size == 1 ? ":#{columns.first}" : "%i[#{columns*' '}]"
                s << ', ' unless name.empty?
              end
              s << "name: :#{name}" unless name.empty?
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