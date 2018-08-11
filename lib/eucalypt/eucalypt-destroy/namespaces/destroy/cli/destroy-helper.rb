require 'eucalypt/eucalypt-destroy/helpers'
require 'eucalypt/helpers'

module Eucalypt
  class Destroy < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Destroy::Helpers
    using Colorize

    desc "helper [NAME]", "Destroys a helper".colorize(:grey)
    def helper(name = nil)
      delete_mvc(:helper, name)
    end
  end
end