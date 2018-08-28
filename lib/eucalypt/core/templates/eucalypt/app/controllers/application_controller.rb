class ApplicationController < Sinatra::Base
  helpers ApplicationHelper if defined? ApplicationHelper

  get '/' do
    erb :index
  end
end