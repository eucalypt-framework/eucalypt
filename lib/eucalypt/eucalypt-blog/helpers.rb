require 'thor'
module Eucalypt
  class Blog < Thor
    module Helpers

      module Array::DateSort
        refine Array.singleton_class do
          def date_sorter(order, obj)
            obj.sort! do |x1, x2|
              if order == :ascending
                x1[:datetime] <=> x2[:datetime]
              else
                x2[:datetime] <=> x1[:datetime]
              end
            end
          end
        end
        refine Array do
          def sort_by_date!(order: :descending)
            obj = self.map!{|x|x[:datetime] = DateTime.strptime(x[:time], "%Y-%m-%d %H:%M:%S"); x}
            Array.date_sorter(order, obj)
          end
          def sort_by_date(order: :descending)
            obj = self.map{|x|x[:datetime] = DateTime.strptime(x[:time], "%Y-%m-%d %H:%M:%S"); x}
            Array.date_sorter(order, obj)
          end
        end
      end

      class Blog
        class << self
          def articles=(val) @@articles = val end
          def articles() @@articles end
          def all() @@articles.map{|md|FrontMatterParser::Parser.parse_file(md).front_matter.symbolize_keys} end
          def search(query) all.select{|post|post[:tags].any?{|tag|tag.include?(query)}} end
        end

        class Article
          def initialize(md) @parsed = FrontMatterParser::Parser.parse_file(md) end
          def front_matter() @parsed.front_matter.symbolize_keys end
          def content() @parsed.content end
          def route() "/#{front_matter[:time].split(' ').first.gsub(?-,?/)}/#{front_matter[:urltitle]}" end
          def asset(file) File.join(front_matter[:assetpath].sub('/assets',''), file) end
        end
      end

      class << self
        private

        def construct_date_regex(date)
          y = date[:year]
          m = date[:month]
          d = date[:day]
          return nil unless y || m || d
          return /#{y}\-#{m}\-#{d}/             if y && m && d
          return /#{y}\-#{m}\-[0-9][0-9]/       if y && m && !d
          return /#{y}\-[0-9][0-9]\-#{d}/       if y && !m && d
          return /[0-9]*\-#{m}\-#{d}/           if !y && m && d
          return /#{y}\-[0-9][0-9]\-[0-9][0-9]/ if y && !m && !d
          return /[0-9]*\-#{m}\-[0-9][0-9]/     if !y && m && !d
          return /[0-9]*\-[0-9][0-9]\-#{d}/     if !y && !m && d
        end

        def clean_directory(base)
          Dir.chdir base do
            Dir[?*].each do |year|
              Dir.chdir year do
                Dir[?*].each do |month|
                  Dir.chdir month do
                    Dir[?*].each do |day|
                      FileUtils.rm_rf day if Dir.empty? day
                    end
                  end
                  FileUtils.rm_rf month if Dir.empty? month
                end
              end
              FileUtils.rm_rf year if Dir.empty? year
            end
          end
        end

        def build_article_hash(articles, article_base)
          articles_hash = Hash.new
          articles.each_with_index do |article,i|
            index_key = (i+1).to_s.to_sym
            articles_hash[index_key] = {}
            articles_hash[index_key][:path] = article
            articles_hash[index_key][:markdown] = article.split(article_base.gsub(/\/$/,'')<<?/).last
            articles_hash[index_key][:identifier] = articles_hash[index_key][:markdown].rpartition(?.).first
            articles_hash[index_key][:base_name] = File.basename articles_hash[index_key][:markdown]
            articles_hash[index_key][:date] = articles_hash[index_key][:identifier].rpartition(?/).first
            articles_hash[index_key][:front_matter] = FrontMatterParser::Parser.parse_file(
              articles_hash[index_key][:path]
            ).front_matter
            title = articles_hash[index_key][:front_matter]['title']
            puts "\e[1m#{index_key}\e[0m: #{articles_hash[index_key][:identifier]}"
            puts "#{' '*(index_key.to_s.length+2)}#{title}" if title
            puts
          end
          articles_hash
        end
      end

    end
  end
end