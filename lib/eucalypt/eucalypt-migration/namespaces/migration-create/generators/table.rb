require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'

module Eucalypt
  module Generators
    module Create
      class Table < Thor::Group
        include Thor::Actions
        include Eucalypt::Helpers
        using String::Builder

        def self.source_root
          File.join File.dirname(File.dirname(File.dirname __dir__))
        end

        def generate(columns: [], options: {}, name:)
          name = Inflect.resources(name.to_s)
          columns.map!{|c| c.split(?:).map{|i| Inflect.resource_keep_inflection(i)}}

          sleep 1
          migration_name = "create_#{name}"
          migration = Eucalypt::Helpers::Migration[title: migration_name, template: 'migration_base.tt']
          return unless migration.create_anyway? if migration.exists?
          config = {migration_class_name: migration_name.camelize}
          template 'migration_base.tt', migration.file_path, config

          sanitized_options = []
          options.each do |k,v|
            if %w[true false].include? v
              sanitized_options << [k,v]
            elsif Eucalypt::Helpers::Numeric.string? v
              sanitized_options << [k,v]
            else
              sanitized_options << [k,":#{v}"]
            end
          end

          insert_into_file migration.file_path, :after => "def change\n" do
            String.build do |s|
              s << "    create_table :#{name}"
              s << ', ' unless sanitized_options.empty?
              s << sanitized_options.map{|opt| "#{opt.first}: #{opt.last}"}*', '
              s << " do |t|\n"
              columns.each do |column|
                n, t = column
                s << "      t.#{t} :#{n}\n"
              end
              s << "    end\n"
            end
          end
        end
      end
    end
  end
end