require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    map %w[--version -v] => :version
    desc "version", "Display installed Eucalypt version".colorize(:grey)
    def version
      puts Eucalypt::VERSION
    end
  end
end