require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/generate/namespaces/generate/cli/generate'

module Eucalypt
  class Security < Thor
    module Helpers
      include Eucalypt::Helpers
      include Eucalypt::Helpers::Messages
      using Colorize

      def create_config_file(type, directory)
        config_relative = File.join 'config', "#{type}.rb"
        config_file = File.join(directory, config_relative)
        Out.warning "#{type.to_s.capitalize} config file #{config_relative.colorize(:bold)} already exists." if File.file? config_file
        template "#{type}.tt", config_file
      end
    end
  end
end