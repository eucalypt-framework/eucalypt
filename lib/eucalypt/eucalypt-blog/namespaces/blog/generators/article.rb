require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def article(urltitle:)
        dt = Hash.new
        dt[:full] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        dt[:date] = dt[:full].split(' ').first

        # Assets path generation
        asset_base = File.join 'app', 'assets', 'blog'
        asset_path = File.join asset_base, dt[:date].gsub(?-,?/), urltitle

        empty_directory(asset_path)

        # Markdown file and path generation
        article_base = File.join 'app', 'views', 'blog', 'markdown'
        article_path = File.join article_base, dt[:date].gsub(?-,?/), "#{urltitle}.md"

        config = {datetime: dt[:full], date: dt[:date], urltitle: urltitle}
        template("views/article_md.tt", article_path, config)
      end
    end
  end
end