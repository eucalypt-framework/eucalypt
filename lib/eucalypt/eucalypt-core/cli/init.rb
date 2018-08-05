require_relative '__base__'
require 'string/builder'
module Eucalypt
  class CLI < Thor
    using String::Builder

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

        app_file_content = String.build do |s|
          msg = "This file should be placed at the root directory of a Eucalypt application."
          version_msg = "Generated with Eucalypt version: #{Eucalypt::VERSION}"
          separator = "# #{?=*msg.size} #\n"
          s << separator
          s << "# #{msg} #\n"
          s << separator
          s << "# #{version_msg.center msg.size, ' '} #\n"
          s << separator
        end

        create_file File.join(root, Eucalypt::APP_FILE), app_file_content

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