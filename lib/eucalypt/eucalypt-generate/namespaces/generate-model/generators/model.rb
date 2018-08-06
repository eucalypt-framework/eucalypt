require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class Model < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, name:)
        model = Inflect.new(:model, name)
        config = {class_name: model.class_name}
        template("model.tt", model.file_path, config)
        template("model_spec.tt", model.spec_path, config) if spec
      end
    end
  end
end