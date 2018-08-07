require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-blog/namespaces/blog/__require__'
require 'eucalypt/eucalypt-blog/namespaces/blog-article/cli/article'

module Eucalypt
  class Blog < Thor
    include Thor::Actions
    include Eucalypt::Helpers

    method_option :route, type: :string, aliases: '-r', default: 'blog'
    desc "setup", "Sets up the blog-aware environment".colorize(:grey)
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

        asset_pipeline_file = File.join(directory, 'config', 'sinatra', 'asset_pipeline.rb')

        File.open(asset_pipeline_file) do |f|
          return if f.read.include? "environment.append_path Eucalypt.path('app', 'assets', 'blog')"
        end

        insert_into_file(
          asset_pipeline_file,
          "\tenvironment.append_path Eucalypt.path('app', 'assets', 'blog')\n",
          after: "set :environment, Sprockets::Environment.new\n"
        )
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
    register(Blog, 'blog', 'blog [COMMAND]', 'Manage blog environment'.colorize(:grey))
  end
end