require 'thor'
require 'eucalypt/helpers'
require_relative 'remove-table'
require_relative 'remove-index'
require_relative 'remove-column'

module Eucalypt
  class MigrationRemove < Thor
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