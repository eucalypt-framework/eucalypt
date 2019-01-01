require 'ipwatch'
class ApplicationController < Sinatra::Base
  set :guard, IPWatch::Guard.new do |config|
    config.default_key = ENV['IP_GUARD_KEY'] || "\xFD\xE1{\x9B\x97n\x01)\xB2Hp^Bg\xE3S"

    config[:site] = IPWatch::Whitelist.new do |list|
      list.path = Eucalypt.path 'config', 'lists', 'whitelist.txt'
    end
  end

  guard.site.add '127.0.0.1', '0.0.0.0'
end