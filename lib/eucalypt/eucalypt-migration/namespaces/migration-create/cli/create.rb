require 'thor'
require 'eucalypt/helpers'
require_relative 'create-table'
require_relative 'create-index'
require_relative 'create-column'

module Eucalypt
  class MigrationCreate < Thor
    include Thor::Actions

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end