require_relative '__base__'
require 'string/builder'
module Eucalypt
  class CLI < Thor
    include Eucalypt::Helpers::Messages
    using String::Builder
    using Colorize
    method_option :git, type: :boolean, default: true, desc: 'Initialize a Git repository'
    method_option :bundle, type: :boolean, default: true, desc: 'Install gems after application generation'
    method_option :blog, type: :boolean, default: false, aliases: '-b', desc: 'Set up the blog environment'
    method_option :route, type: :string, default: 'blog', aliases: '-r', desc: 'Specify a route for the blog application'
    method_option :silence, type: :boolean, default: false, aliases: '-s', desc: 'Silence `git init` and `bundle install` commands'
    method_option :warden, type: :boolean, default: false, aliases: '-w', desc: 'Set up Warden authentication'
    method_option :pundit, type: :boolean, default: false, aliases: '-p', desc: 'Set up Pundit authorization'
    desc "init [NAME]", "Sets up your application".colorize(:grey)
    def init(name)
      current_directory = File.expand_path ?.
      name = Inflect.route(name)
      root = File.join(current_directory, name)
      if Dir.exist? root
        Out.error "Directory #{name.colorize(:bold)} already exists."
        return
      else
        if File.file? File.join(current_directory, Eucalypt::APP_FILE)
          Eucalypt::Error.found_app_file
          initialize_anyway = ask "Initialize application anyway?", limited_to: %w[y Y Yes YES n N No NO]
          return unless %w[y Y Yes YES].include? initialize_anyway
        end

        Out.setup "Setting up Eucalypt application..."
        Eucalypt::CLI.source_root File.join(File.dirname(__dir__), 'templates')

        directory 'eucalypt', root

        app_file_content = String.build do |s|
          msg = "This file should be placed in the root directory of a Eucalypt application."
          version_msg = "Generated with Eucalypt version: #{Eucalypt::VERSION}"
          separator = "# #{?=*msg.size} #\n"
          s << separator
          s << "# #{msg} #\n"
          s << separator
          s << "# #{version_msg.center msg.size, ' '} #\n"
          s << separator.chomp
        end

        create_file File.join(root, Eucalypt::APP_FILE), app_file_content

        config = {version: Eucalypt::VERSION}
        template 'Gemfile.tt', File.join(root, 'Gemfile'), config

        if options[:blog]
          inside(root) do
            args = %w[blog setup]
            args << '-r' << options[:route] if options[:route]
            Eucalypt::CLI.start(args)
          end
        end

        inside(root) do
          Eucalypt::CLI.start %w[security warden setup] if options[:warden]
          Eucalypt::CLI.start %w[security pundit setup] if options[:warden] && options[:pundit]
        end

        puts if options[:git] || options[:bundle]
        inside(root) { run(options[:silence] ? 'git init --quiet' : 'git init') } if options[:git]
        puts if options[:git] && options[:bundle]
        inside(root) { run(options[:silence] ? 'bundle install --quiet' : 'bundle install') } if options[:bundle]
      end
    end
  end
end