require 'thor'
require 'eucalypt/helpers'
require_relative 'drop-table'
require_relative 'drop-index'
require_relative 'drop-column'
require 'eucalypt/list'

module Eucalypt
  class MigrationDrop < Thor
    include Thor::Actions
    extend Eucalypt::List

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end