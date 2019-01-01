require 'sinatra'
require 'securerandom'
class ApplicationController < Sinatra::Base
  if settings.methods(false).include?(:maintenance)
    if settings.maintenance
      define_singleton_method(:maintenance) do |&block|
        get '*', &block
        post '*', &block
        put '*', &block
        patch '*', &block
        delete '*', &block
        options '*', &block
        link '*', &block
        unlink '*', &block
      end
    else
      define_singleton_method(:maintenance) {|&block| get 3.times.map{"/#{SecureRandom.hex 8}"}.join(), &block}
    end
  else
    define_singleton_method(:maintenance) {|&block| get 3.times.map{"/#{SecureRandom.hex 8}"}.join(), &block}
  end
end