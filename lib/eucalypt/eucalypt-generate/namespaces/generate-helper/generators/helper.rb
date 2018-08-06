require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class Helper < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, name:)
        helper = Inflect.new(:helper, name)
        config = {class_name: helper.class_name}
        template("helper.tt", helper.file_path, config)
        template("helper_spec.tt", helper.spec_path, config) if spec
      end
    end
  end
end