require 'thor'
require 'eucalypt/helpers/gemfile'
class GemfileCLI < Thor
  include Thor::Actions
  include Eucalypt::Helpers::Gemfile

  desc '', ''
  method_option :gems, type: :hash, aliases: '-g'
  def add(description, directory)
    gems = {}
    options[:gems].each do |gem, version|
      gems[gem.to_sym] = version
    end
    silence { gemfile_add description, gems, directory }
  end
end