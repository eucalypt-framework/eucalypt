require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    map %[-H] => :__help
    desc "-H [COMMAND]", "Show additional information for a command".colorize(:grey)
    def __help(*args)
      Eucalypt::CLI.start args.insert(args.size-1, 'help')
    end
  end
end