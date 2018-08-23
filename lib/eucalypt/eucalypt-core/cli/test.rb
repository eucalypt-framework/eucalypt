require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using Colorize
    option :summarized, type: :boolean, default: false, aliases: '-s', desc: 'rspec -fd spec'
    desc "test", "Run all application tests".colorize(:grey)
    def test
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        exec (options[:summarized] ? "rspec -fd spec" : "rspec spec")
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end