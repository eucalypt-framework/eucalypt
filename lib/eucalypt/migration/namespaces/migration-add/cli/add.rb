require 'thor'
require 'eucalypt/helpers'
require_relative 'add-index'
require_relative 'add-column'
require 'eucalypt/list'

module Eucalypt
  class MigrationAdd < Thor
    include Thor::Actions
    extend Eucalypt::List

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end