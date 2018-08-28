require 'eucalypt/destroy/helpers'
require 'eucalypt/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Destroy::Helpers
    using Colorize

    desc "model [NAME]", "Destroys a model".colorize(:grey)
    def model(name = nil)
      delete_mvc(:model, name)
    end
  end
end