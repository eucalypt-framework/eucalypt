require 'thor'
require 'eucalypt/helpers'
require_relative 'rename-column'
require_relative 'rename-index'
require_relative 'rename-table'

module Eucalypt
  class MigrationRename < Thor
    include Thor::Actions

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end