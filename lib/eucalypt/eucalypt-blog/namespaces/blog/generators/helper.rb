require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def helper
        template File.join('helper','helper.tt'), File.join('app','helpers','blog_helper.rb')
        template File.join('helper','helper_spec.tt'), File.join('spec','helpers','blog_helper_spec.rb')
      end
    end
  end
end