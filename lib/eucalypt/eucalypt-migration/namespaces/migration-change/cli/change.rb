require 'thor'
require 'eucalypt/helpers'
require_relative 'change-column'

module Eucalypt
  class MigrationChange < Thor
    include Thor::Actions

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} migration #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end