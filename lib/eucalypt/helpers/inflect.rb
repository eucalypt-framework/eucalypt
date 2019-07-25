require 'active_support'
require 'active_support/core_ext'

module Eucalypt
  module Helpers
    class Inflect
      class << self
        def route(string)
          string.
          underscore.
          parameterize(separator: ?-).
          gsub(?_,?-).
          sub(/(^\-+?)(?=[A-Za-z0-9])/,'').
          reverse.
          sub(/(^\-+?)(?=[A-Za-z0-9])/,'').
          reverse.
          gsub(/\-\-+/,?-)
        end

        def resource(string)
          route(string).gsub(?-,?_).singularize
        end

        def resources(string)
          route(string).gsub(?-,?_).pluralize
        end

        def resource_keep_inflection(string)
          route(string).gsub(?-,?_)
        end

        def constant(string)
          resource(string).camelize
        end

        def constant_pluralize(string)
          resources(string).camelize
        end

        %i[controller helper].each do |type|
          define_method type do |string|
            s = resource(string.singularize)
            if s.end_with? "_#{type}"
              name = s.split("_#{type}").first
              "#{name.singularize}_#{type}"
            else
              "#{s.singularize}_#{type}"
            end
          end
        end

        def model(string)
          resource(string.singularize)
        end
      end

      attr_reader :name,
                  :file_name, :file_path,
                  :spec_name, :spec_path,
                  :class_name, :route_name,
                  :resource, :resources,
                  :constant

      def initialize(type, name)
        type = type
        @name = Inflect.send(type, name.to_s)
        @file_name = "#{@name}.rb"
        @file_path = File.join('app', type.to_s.pluralize, file_name)
        @spec_name = "#{@name}_spec.rb"
        @spec_path = File.join('spec', type.to_s.pluralize, spec_name)
        @class_name = Inflect.constant(@name)
        @route_name = Inflect.route(@name.gsub "_#{type}", '')
        @resource = Inflect.resource(@route_name)
        @resources = Inflect.resources(@route_name)
        @constant = Inflect.constant(@route_name)
      end
    end
  end
end