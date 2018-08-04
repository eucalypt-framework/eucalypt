require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def views
        config = {erb: ["<%= application :css, :js %>","<%= yield %>"]}
        template("views/article_layout.erb", "app/views/layouts/blog/article.erb", config)
        template("views/articles_layout.erb", "app/views/layouts/blog/articles.erb", config)

        config = {erb: "<%= content %>"}
        template("views/article.erb", "app/views/blog/article.erb", config)

        config = {erb: "<%= @articles %>"}
        template("views/articles.erb", "app/views/blog/articles.erb", config)
        template("views/search.erb", "app/views/blog/search.erb", config)
      end
    end
  end
end