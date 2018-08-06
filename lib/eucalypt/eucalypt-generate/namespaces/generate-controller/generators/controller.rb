require 'active_support'
require 'active_support/core_ext'
require 'string/builder'
require 'thor'

module Eucalypt
  module Generators
    class Controller < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers
      using String::Builder

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, rest: false, policy: false, name:)
        controller = Inflect.new(:controller, name)

        route = '/' << (rest ? controller.route_name.pluralize : controller.route_name)

        controller_file_name = String.build do |s|
          s << 'policy_' if policy
          s << 'rest_' if rest
          s << 'controller.tt'
        end
        controller_template = File.join 'controller', controller_file_name

        helper = Inflect.new(:helper, controller.resource)

        config = {
          route: route,
          constant: controller.constant,
          class_name: controller.class_name,
          helper_class_name: helper.class_name,
          resource: controller.resource,
          resources: controller.resources
        }

        template(controller_template, controller.file_path, config)
        template("controller_spec.tt", controller.spec_path, config) if spec
      end
    end
  end
end
