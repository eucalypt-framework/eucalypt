require 'sinatra'
class ApplicationController < Sinatra::Base
  helpers do
    def partial(template, **locals)
      path = template.to_s.start_with? 'partials/' ? template : "partials/#{template}"
      erb template.to_sym, layout: false, locals: locals
    end
  end
end