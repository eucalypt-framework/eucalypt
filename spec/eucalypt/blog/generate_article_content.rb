require 'string/builder'
module BlogHelpers
  using String::Builder
  def generate_article_content(**hash)
    String.build do |s|
      s << "---\n"
      hash.each do |k,v|
        s << "#{k}: #{v.inspect}\n"
      end
      s << "---\n"
    end
  end
end