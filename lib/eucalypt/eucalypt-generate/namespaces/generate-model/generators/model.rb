require 'active_support'
require 'active_support/core_ext'
require 'thor'

module Eucalypt
  module Generators
    class Model < Thor::Group
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, name:)
        name = name.to_s
        file_name = "#{name.singularize.underscore}.rb"
        file_path = File.join 'app', 'models', file_name
        spec_name = file_name.gsub('.rb','_spec.rb')
        spec_path = File.join 'spec', 'models', spec_name
        name = name.singularize.camelize

        config = {name: name}
        template("model.tt", file_path, config)
        template("model_spec.tt", spec_path, config) if spec
      end
    end
  end
end