require_relative '__base__'
module Eucalypt
  class CLI < Thor
    desc "console", "Starts an interactive console with all application files loaded"
    def console
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        exec "chmod +x bin/console && bundle exec bin/console"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end