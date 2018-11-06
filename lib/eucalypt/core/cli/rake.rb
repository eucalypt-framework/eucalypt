require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    desc "rake", "Run all database migrations".colorize(:grey)
    def rake
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        exec "bundle exec rake db:migrate"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end