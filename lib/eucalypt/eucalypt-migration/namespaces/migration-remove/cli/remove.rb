require 'thor'
require 'eucalypt/helpers'
require_relative 'remove-table'
require_relative 'remove-index'
require_relative 'remove-column'

module Eucalypt
  class MigrationRemove < Thor
    include Thor::Actions

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end