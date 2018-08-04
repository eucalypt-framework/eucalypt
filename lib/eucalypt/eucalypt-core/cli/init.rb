require_relative '__base__'
module Eucalypt
  class CLI < Thor
    method_option :blog, type: :boolean, default: false, aliases: '-b'
    method_option :route, type: :string, aliases: '-r'
    desc "init [NAME]", "Sets up the application"
    def init(name)
      current_directory = File.expand_path ?.
      root = File.join(current_directory, name)
      if Dir.exist? root
        puts "\e[1;91mERROR\e[0m: Directory \e[1m#{name}\e[0m already exists."
        return
      else
        puts "\n\e[94;4mSetting up Eucalypt application...\e[0m"
        Eucalypt::CLI.source_root File.dirname(__dir__)
        directory 'templates/eucalypt', root

        config = {version: Eucalypt::VERSION}
        template 'templates/Gemfile.tt', File.join(root, 'Gemfile'), config

        return unless options[:blog]

        Dir.chdir(root) do
          args = %w[blog setup]
          args << '-r' << options[:route] if options[:route]
          Eucalypt::CLI.start(args)
        end
      end
    end
  end
end