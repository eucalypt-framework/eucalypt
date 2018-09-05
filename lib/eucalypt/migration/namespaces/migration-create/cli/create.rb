require 'thor'
require 'eucalypt/helpers'
require_relative 'create-table'
require 'eucalypt/list'

module Eucalypt
  class MigrationCreate < Thor
    include Thor::Actions
    extend Eucalypt::List

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end