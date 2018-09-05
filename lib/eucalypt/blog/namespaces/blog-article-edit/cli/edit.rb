require 'thor'
require 'eucalypt/list'
require_relative 'edit-datetime'
require_relative 'edit-urltitle'

class Eucalypt::BlogArticleEdit < Thor
  extend Eucalypt::List

  def self.banner(task, namespace = false, subcommand = true)
    "#{basename} blog article #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
  end
end