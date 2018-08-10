$LOAD_PATH.unshift File.join __dir__, '..', 'lib'
require "bundler/setup"
require 'eucalypt'
require 'fileutils'
require 'regexp-examples'

Dir.glob File.join(__dir__, 'support', '*.rb'), &method(:require)

RSpec.configure do |config|
  config.after(:all) { clear_tmp }
end

include Eucalypt