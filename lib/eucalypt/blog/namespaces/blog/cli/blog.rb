require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/list'
require 'eucalypt/blog/namespaces/blog/__require__'
require 'eucalypt/blog/namespaces/blog-article/cli/article'

module Eucalypt
  class Blog < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    include Eucalypt::Helpers::Gemfile
    using Colorize
    extend Eucalypt::List

    option :route, type: :string, aliases: '-r', default: 'blog', desc: "The route at which the blog lies"
    desc "setup", "Sets up the blog environment".colorize(:grey)
    def setup
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        Out.setup 'Setting up blog environment...'

        gemfile_add(
          'Markdown and YAML front-matter parsing',
          {front_matter_parser: '0.2.0', rdiscount: '~> 2.2'},
          directory
        )

        generator = Eucalypt::Generators::Blog.new
        generator.destination_root = directory
        generator.helper
        generator.controller(route: options[:route])
        generator.views
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      basename + ' ' + task.formatted_usage(self, true, subcommand).split(':').join(' ')
    end

    register(Eucalypt::BlogArticle, 'article', 'article [COMMAND]', 'Create, edit and destroy blog articles'.colorize(:grey))
  end

  class CLI < Thor
    include Eucalypt::Helpers
    using Colorize
    register(Blog, 'blog', 'blog [COMMAND]', 'Manage static blog environment'.colorize(:grey))
  end
end