require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-blog/helpers'
require 'eucalypt/eucalypt-blog/namespaces/blog/__require__'
require 'eucalypt/eucalypt-blog/namespaces/blog-article-edit/cli/edit-datetime'
require 'eucalypt/eucalypt-blog/namespaces/blog-article-edit/cli/edit-urltitle'

module Eucalypt
  class BlogArticle < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Blog::Helpers

    method_option :descending, type: :boolean, aliases: '-d', default: true
    method_option :ascending, type: :boolean, aliases: '-a', default: false
    method_option :tag, type: :string, aliases: '-t', default: String.new
    method_option :year, type: :string, aliases: '-Y'
    method_option :month, type: :string, aliases: '-M'
    method_option :day, type: :string, aliases: '-D'
    desc "list", "Display the metadata of blog articles".colorize(:grey)
    def list
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        return unless gemfile_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        generator = Eucalypt::Generators::Blog.new
        generator.destination_root = directory
        generator.list(
          options[:tag],
          options[:ascending] ? :ascending : :descending,
          {year: options[:year], month: options[:month], day: options[:day]}
        )
      else
        Eucalypt::Error.wrong_directory
      end
    end

    desc "generate [URLTITLE]", "Create a new blog article".colorize(:grey)
    def generate(urltitle)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        return unless gemfile_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        urltitle = Inflect.route(urltitle) if urltitle

        generator = Eucalypt::Generators::Blog.new
        generator.destination_root = directory
        generator.article(urltitle: urltitle)
      else
        Eucalypt::Error.wrong_directory
      end
    end

    desc "destroy [URLTITLE]", "Destroys a blog article".colorize(:grey)
    def destroy(urltitle = nil)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        return unless gemfile_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        markdown_base = File.join directory, 'app', 'views', 'blog', 'markdown'
        articles_path = File.join '**', (urltitle ? "#{urltitle}.md" : "*.md")

        articles = Dir[File.join markdown_base, articles_path]
        if articles.empty?
          Eucalypt::Error.no_articles
          return
        end

        Eucalypt::Error.delete_article_warning; puts

        asset_base = File.join directory, 'app', 'assets', 'blog'
        articles_hash = {}
        article_numbers = []
        articles.each_with_index do |article, i|
          number = (i+1).to_s
          article_numbers << number
          identifier = article.split(markdown_base.gsub(/\/$/,'')<<?/).last.split('.md').first
          articles_hash[number.to_sym] = identifier
          title = FrontMatterParser::Parser.parse_file(article).front_matter['title']
          puts "#{number.colorize(:bold)}: #{identifier}#{title ? " - #{title}" : ''}"
        end

        article_number = ask("\nEnter the number of the article to delete:", limited_to: article_numbers)
        article = articles_hash[article_number.to_sym]
        delete_article = ask Out.warning_message("Delete article #{article.colorize(:bold)}?"), limited_to: %w[y Y Yes YES n N No NO]
        return unless %w[y Y Yes YES].include? delete_article
        remove_file File.join(markdown_base, "#{article}.md")
        paths = article.rpartition ?/
        Dir.chdir(File.join asset_base, paths.first) { FileUtils.rm_rf paths.last }

        Eucalypt::Blog::Helpers.send :clean_directory, asset_base
        Eucalypt::Blog::Helpers.send :clean_directory, markdown_base
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} blog #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end

    class Eucalypt::BlogArticleEdit < Thor
      def self.banner(task, namespace = false, subcommand = true)
        "#{basename} blog article #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
      end
    end

    register(Eucalypt::BlogArticleEdit, 'edit', 'edit [COMMAND]', 'Edit blog articles'.colorize(:grey))
  end
end