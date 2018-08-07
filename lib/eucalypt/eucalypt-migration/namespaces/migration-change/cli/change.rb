require 'thor'
require 'eucalypt/helpers'
require_relative 'change-column'

module Eucalypt
  class MigrationChange < Thor
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