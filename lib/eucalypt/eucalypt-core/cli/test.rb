require_relative '__base__'
module Eucalypt
  class CLI < Thor
    desc "test", "Run all application specs"
    def test
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        exec "rspec -fd spec"
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end