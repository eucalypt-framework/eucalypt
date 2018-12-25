require 'sinatra'
class ApplicationController < Sinatra::Base
  get('*') { redirect '/maintenance.html' } if settings.maintenance
end