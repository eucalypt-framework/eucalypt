$LOAD_PATH.unshift File.join __dir__, '..', 'lib'
require 'bundler/setup'
require 'eucalypt'
require 'fileutils'
require 'regexp-examples'
require 'colorize'

Dir.glob File.join(__dir__, 'support', '*.rb'), &method(:require)

RSpec.configure do |config|
  config.include Temporary
  config.before(:all) { @tmp = Temporary::DIRECTORY }
  config.after(:all) { Temporary.clear }
end

include Eucalypt