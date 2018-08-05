require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      using Array::DateSort
      using String::Builder

      def list(tag, order, date)
        chars = {corner: ?+, vertical: ?║, horizontal: ?═}

        puts

        files = Dir.glob(File.join(self.destination_root,"app/views/blog/markdown/**/*.md"))
        if files.empty?
          puts "0 article(s) found."
          return
        end

        date_regex = Eucalypt::Blog::Helpers.send :construct_date_regex, date

        metadata = files.map{|md|FrontMatterParser::Parser.parse_file(md).front_matter.symbolize_keys}
        metadata.select!{|post|post[:tags].any?{|t|t.include?(tag)}} unless tag.empty?
        metadata.select!{|post|date_regex.match? post[:time].split.first} if date_regex
        metadata.sort_by_date!(order: order)

        number = metadata.length
        if number == 0
          puts "0 article(s) found.\n"
          return
        else
          puts "#{metadata.length} article(s) found.\n"
        end

        longest = 0
        metadata.each do |article|
          article.each do |k,v|
            next if %i[desc datetime].include? k
            str = "#{k}: #{v}"
            longest = str.length if longest < str.length
          end
        end

        output = String.build "\n" do |s|
          s << (chars[:corner]+chars[:horizontal]*(longest+2)+chars[:corner]+"\n")
          metadata.each do |article|
            article.each do |k,v|
              next if k == :datetime
              str = "#{k}: #{v}"
              if k == :desc
                value = v.to_s
                rel = longest-(k.length+5) # 5 is from ": " and "..."
                unless str.length <= longest
                  str = "#{k}: #{value.length > rel ? "#{value[0...rel]}..." : value}"
                end
              end
              len = str.ljust(longest,' ').length-str.length
              s << "#{chars[:vertical]} "
              s << "#{k.to_s.colorize(:magenta)}: #{str[(k.to_s.length+2)..-1]}"
              s << ' '*len
              s << " #{chars[:vertical]}\n"
            end
            s << (chars[:corner]+chars[:horizontal]*(longest+2)+chars[:corner]+"\n")
          end
        end

        puts output
      end
    end
  end
end