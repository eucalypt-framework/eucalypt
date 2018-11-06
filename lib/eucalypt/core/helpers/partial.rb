require 'sinatra'
class ApplicationController < Sinatra::Base
  helpers do
    def partial(template, **locals)
      erb template.to_sym, layout: false, locals: locals
    end
  end
end