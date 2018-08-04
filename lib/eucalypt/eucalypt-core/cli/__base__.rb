require 'eucalypt/errors'
require 'eucalypt/version'
require 'thor'

module Eucalypt
  class CLI < Thor
    include Thor::Actions
  end
end