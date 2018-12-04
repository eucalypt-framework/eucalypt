require_relative '__base__'
module Eucalypt
  class CLI < Thor
    using String::Builder
    using Colorize
    option :summarized, type: :boolean, default: false, aliases: '-s', desc: 'rspec -fd spec'
    desc "test", "Run all application tests".colorize(:grey)
    def test
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        cmd = 'bundle exec rspec '.build do |s|
          s << '-fd ' if options[:summarized]
          s << 'spec'
        end
        exec cmd
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end