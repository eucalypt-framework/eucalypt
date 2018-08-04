require 'thor'
require 'front_matter_parser'
require 'string/builder'
require 'active_support'
require 'active_support/core_ext'

require 'eucalypt/eucalypt-blog/helpers'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      include Thor::Actions
      include Eucalypt::Blog::Helpers

      def self.source_root
        File.join __dir__, 'templates'
      end
    end
  end
end