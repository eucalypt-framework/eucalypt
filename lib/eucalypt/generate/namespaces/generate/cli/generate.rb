require 'eucalypt/generate/namespaces/generate-controller/cli/generate-controller'
require 'eucalypt/generate/namespaces/generate-helper/cli/generate-helper'
require 'eucalypt/generate/namespaces/generate-model/cli/generate-model'
require_relative 'generate-scaffold'
require 'eucalypt/helpers'
require 'eucalypt/list'

module Eucalypt
  class Generate < Thor
    include Eucalypt::Helpers
    using Colorize
    extend Eucalypt::List

    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
    end
  end
  class CLI < Thor
    include Eucalypt::Helpers
    using Colorize
    register(Generate, 'generate', 'generate [COMMAND]', 'Generate individual MVC files or scaffolds'.colorize(:grey))
  end
end