require 'eucalypt/eucalypt-destroy/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Destroy::Helpers

    desc "model [NAME]", "Destroys a model".colorize(:grey)
    def model(name = nil)
      delete_mvc(:model, name)
    end
  end
end