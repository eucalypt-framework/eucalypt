require_relative '__base__'
module Eucalypt
  class CLI < Thor
    desc "test", "Run all application specs".colorize(:grey)
    def test
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        exec "rspec -fd spec"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end