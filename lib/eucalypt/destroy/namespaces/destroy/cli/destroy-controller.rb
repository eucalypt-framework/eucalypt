require 'eucalypt/destroy/helpers'
require 'eucalypt/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Destroy::Helpers
    using Colorize

    desc "controller [NAME]", "Destroys a controller".colorize(:grey)
    def controller(name = nil)
      delete_mvc(:controller, name)
    end
  end
end