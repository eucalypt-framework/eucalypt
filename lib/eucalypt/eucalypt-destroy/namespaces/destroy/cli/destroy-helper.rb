require 'eucalypt/eucalypt-destroy/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Destroy::Helpers

    desc "helper [NAME]", "Destroys a helper"
    def helper(name = nil)
      delete_mvc(:helper, name)
    end
  end
end