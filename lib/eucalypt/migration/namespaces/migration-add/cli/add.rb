require 'thor'
require 'eucalypt/helpers'
require_relative 'add-index'
require_relative 'add-column'

module Eucalypt
  class MigrationAdd < Thor
    include Thor::Actions

    class << self
      require 'eucalypt/list'
      include Eucalypt::List
      def banner(task, namespace = false, subcommand = true)
        "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
      end
    end
  end
end