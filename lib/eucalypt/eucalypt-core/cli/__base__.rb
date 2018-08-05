require 'eucalypt/errors'
require 'eucalypt/version'
require 'eucalypt/helpers'
require 'thor'

module Eucalypt
  class CLI < Thor
    include Thor::Actions
    include Eucalypt::Helpers
  end
end