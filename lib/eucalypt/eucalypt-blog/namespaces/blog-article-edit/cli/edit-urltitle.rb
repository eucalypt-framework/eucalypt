require 'thor'
require 'active_support'
require 'active_support/core_ext'

require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-blog/helpers'

module Eucalypt
  class BlogArticleEdit < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Blog::Helpers

    desc "urltitle [URLTITLE]", "Edits the urltitle of a blog post"
    def urltitle(urltitle = nil)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        return unless gem_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        article_base = File.join directory, 'app', 'views', 'blog', 'markdown'
        article_asset_base = File.join directory, 'app', 'assets', 'blog'
        articles = Dir[File.join article_base, '**/*.md']

        if articles.empty?
          Eucalypt::Error.no_articles
          return
        end

        if urltitle
          urltitle = urltitle.downcase
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
        update = ask("\e[1;93mWARNING\e[0m: Change urltitle from \e[1m#{current_urltitle}\e[0m to \e[1m#{new_urltitle}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])

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