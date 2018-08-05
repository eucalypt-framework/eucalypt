require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def views
        config = {erb: ["<%= application :css, :js %>","<%= yield %>"]}
        template File.join('views','article_layout.erb'), File.join('app','views','layouts','blog','article.erb'), config
        template File.join('views','articles_layout.erb'), File.join('app','views','layouts','blog','articles.erb'), config

        config = {erb: "<%= content %>"}
        template File.join('views','article.erb'), File.join('app','views','blog','article.erb'), config

        config = {erb: "<%= @articles %>"}
        template File.join('views','articles.erb'), File.join('app','views','blog','articles.erb'), config
        template File.join('views','search.erb'), File.join('app','views','blog','search.erb'), config
      end
    end
  end
end