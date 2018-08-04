require 'active_support'
require 'active_support/core_ext'
require 'thor'

module Eucalypt
  module Generators
    class Controller < Thor::Group
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate(spec: true, rest: false, name:)
        name = name.to_s
        file_name = name.downcase.include?('controller') ? "#{name.underscore}.rb" : "#{name.singularize.underscore}_controller.rb"
        file_path = File.join 'app', 'controllers', file_name
        class_name = name.downcase.include?('controller') ? name.camelize : "#{name.singularize.camelize}Controller"
        spec_name = file_name.gsub('.rb','_spec.rb')
        spec_path = File.join 'spec', 'controllers', spec_name

        tokens = file_name.split(?_)
        route_name = tokens.first(tokens.size-1)*?-
        route = "/#{rest ? route_name.pluralize : route_name}"

        controller_template = "controller/#{rest ? 'rest_' : ''}controller.tt"

        config = {route: route, class_name: class_name}
        template(controller_template, file_path, config)
        template("controller_spec.tt", spec_path, config) if spec
      end
    end
  end
end
