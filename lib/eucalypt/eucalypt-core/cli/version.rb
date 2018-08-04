require_relative '__base__'
module Eucalypt
  class CLI < Thor
    map %w[--version -v] => :__print_version
    desc "--version, -v", "Display installed Eucalypt version"
    def __print_version
      puts Eucalypt::VERSION
    end
  end
end