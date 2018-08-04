require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def helper
        template("helper/helper.tt", "app/helpers/blog_helper.rb")
        template("helper/helper_spec.tt", "spec/helpers/blog_helper_spec.rb")
      end
    end
  end
end