require_relative 'destroy-scaffold'
require 'eucalypt/helpers'

module Eucalypt
  class Destroy < Thor
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
    register(Destroy, 'destroy', 'destroy [COMMAND]', 'Destroy individual MVC files or scaffolds'.colorize(:grey))
  end
end