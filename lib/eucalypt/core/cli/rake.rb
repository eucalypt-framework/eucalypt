require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    desc "rake [TASK]", "Run a rake task".colorize(:grey)
    def rake(task)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        exec "bundle exec rake #{task}"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end