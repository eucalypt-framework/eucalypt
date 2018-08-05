require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def controller(route:)
        route = route[0] == ?/ ? route : "/#{route}"
        config = {route: route}
        template File.join('controller','controller.tt'), File.join('app','controllers','blog_controller.rb'), config
        template File.join('controller','controller_spec.tt'), File.join('spec','controllers','blog_controller_spec.rb')
      end
    end
  end
end