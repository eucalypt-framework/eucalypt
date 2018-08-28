require 'thor'
require 'active_support'
require 'active_support/core_ext'

require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/blog/helpers'

module Eucalypt
  class BlogArticleEdit < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    include Eucalypt::Blog::Helpers
    using Colorize

    desc "urltitle [URLTITLE]", "Edits the urltitle of a blog post".colorize(:grey)
    def urltitle(urltitle = nil)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        return unless Gemfile.check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        article_base = File.join directory, 'app', 'views', 'blog', 'markdown'
        article_asset_base = File.join directory, 'app', 'assets', 'blog'
        articles = Dir[File.join article_base, '**', '*.md']

        if articles.empty?
          Eucalypt::Error.no_articles
          return
        end

        if urltitle
          if articles.any? {|a| File.basename(a, '.md') == urltitle}
            articles = articles.select {|a| File.basename(a, '.md') == urltitle}
          else
            Eucalypt::Error.no_articles
            return
          end
        end

        articles_hash = Eucalypt::Blog::Helpers.send :build_article_hash, articles, article_base
        article_number = ask("Enter the number of the article to edit:", limited_to: articles_hash.keys.map(&:to_s))
        article = articles_hash[article_number.to_sym]

        current_urltitle = article[:front_matter]['urltitle']
        new_urltitle = ask("Enter new urltitle:").parameterize
        update = ask Out.warning_message("Change urltitle from #{current_urltitle.colorize(:bold)} to #{new_urltitle.colorize(:bold)}?"), limited_to: %w[y Y Yes YES n N No NO]
        return unless %w[y Y Yes YES].include? update

        gsub_file(
          article[:path],
          /urltitle\:.*\n/,
          "urltitle: \"#{new_urltitle}\"\n"
        )

        gsub_file(
          article[:path],
          /\/assets\/#{article[:date]}\/#{current_urltitle}/,
          "/assets/#{article[:date]}/#{new_urltitle}"
        )

        Dir.chdir(File.join article_base, article[:date]) do
          FileUtils.mv(article[:base_name], "#{new_urltitle}.md")
        end

        Dir.chdir(File.join article_asset_base, article[:date]) do
          FileUtils.mv(File.basename(article[:base_name], '.md'), new_urltitle)
        end

      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end