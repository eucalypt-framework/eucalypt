require 'active_support'
require 'active_support/core_ext'
require 'thor'

module Eucalypt
  module Generators
    class Helper < Thor::Group
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, name:)
        name = name.to_s
        file_name = name.downcase.include?('helper') ? "#{name.underscore}.rb" : "#{name.singularize.underscore}_helper.rb"
        file_path = File.join 'app', 'helpers', file_name
        module_name = name.downcase.include?('helper') ? name.camelize : "#{name.singularize.camelize}Helper"
        spec_name = file_name.gsub('.rb','_spec.rb')
        spec_path = File.join 'spec', 'helpers', spec_name

        config = {module_name: module_name}
        template("helper.tt", file_path, config)
        template("helper_spec.tt", spec_path, config) if spec
      end
    end
  end
end