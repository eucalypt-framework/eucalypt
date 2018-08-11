require 'eucalypt/eucalypt-generate/namespaces/generate-controller/cli/generate-controller'
require 'eucalypt/eucalypt-generate/namespaces/generate-helper/cli/generate-helper'
require 'eucalypt/eucalypt-generate/namespaces/generate-model/cli/generate-model'
require_relative 'generate-scaffold'
require 'eucalypt/helpers'

module Eucalypt
  class Generate < Thor
    include Eucalypt::Helpers
    using Colorize
    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
      end
    end
  end
  class CLI < Thor
    include Eucalypt::Helpers
    using Colorize
    register(Generate, 'generate', 'generate [COMMAND]', 'Generate individual MVC files or scaffolds'.colorize(:grey))
  end
end