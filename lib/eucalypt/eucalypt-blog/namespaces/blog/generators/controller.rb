require 'eucalypt/eucalypt-blog/namespaces/blog/__base__'

module Eucalypt
  module Generators
    class Blog < Thor::Group
      def controller(route:)
        route = route[0] == ?/ ? route : "/#{route}"
        config = {route: route}
        template("controller/controller.tt", "app/controllers/blog_controller.rb", config)
        template("controller/controller_spec.tt", "spec/controllers/blog_controller_spec.rb")
      end
    end
  end
end