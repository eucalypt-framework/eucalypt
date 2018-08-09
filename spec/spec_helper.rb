$LOAD_PATH.unshift File.join __dir__, '..', 'lib'
#require "bundler/setup"
require 'eucalypt'
require 'fileutils'

Dir.glob __dir__, 'support', '*.rb', &method(:require)

RSpec.configure do |config|
  config.after :all do
    FileUtils.rm_rf 'tmp'
  end
end