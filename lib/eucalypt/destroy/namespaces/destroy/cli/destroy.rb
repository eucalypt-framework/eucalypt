require_relative 'destroy-scaffold'
require 'eucalypt/helpers'
require 'eucalypt/list'

module Eucalypt
  class Destroy < Thor
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
    register(Destroy, 'destroy', 'destroy [COMMAND]', 'Destroy individual MVC files or scaffolds'.colorize(:grey))
  end
end