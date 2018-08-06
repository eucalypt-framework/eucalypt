require 'eucalypt/eucalypt-destroy/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Destroy::Helpers

    desc "controller [NAME]", "Destroys a controller".colorize(:grey)
    def controller(name = nil)
      delete_mvc(:controller, name)
    end
  end
end