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
        Out.error "Directory #{name.colorize(:bold)} already exists."
        return
      else
        Out.setup 'Setting up Eucalypt application...'
        Eucalypt::CLI.source_root File.join(File.dirname(__dir__), 'templates')

        directory 'eucalypt', root

        config = {version: Eucalypt::VERSION}
        template 'Gemfile.tt', File.join(root, 'Gemfile'), config

        if options[:blog]
          Dir.chdir(root) do
            args = %w[blog setup]
            args << '-r' << options[:route] if options[:route]
            Eucalypt::CLI.start(args)
          end
        end
      end
    end
  end
end