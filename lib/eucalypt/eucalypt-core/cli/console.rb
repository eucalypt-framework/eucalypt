require_relative '__base__'
module Eucalypt
  class CLI < Thor
    desc "console", "Interactive console with all files loaded".colorize(:grey)
    def console
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        inside(directory) { chmod('bin/console', '+x') }
        exec "bundle exec bin/console"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end