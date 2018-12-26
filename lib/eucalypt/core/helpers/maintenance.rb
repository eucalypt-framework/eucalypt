require 'sinatra'
class ApplicationController < Sinatra::Base
  define_singleton_method(:maintenance) {|&block| get '*', &block}
end