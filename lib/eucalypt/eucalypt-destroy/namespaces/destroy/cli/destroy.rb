require_relative 'destroy-scaffold'

module Eucalypt
  class Destroy < Thor
    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
    end
  end
  class CLI < Thor
    register(Destroy, 'destroy', 'destroy [COMMAND]', 'Destroy models, controllers and helpers')
  end
end