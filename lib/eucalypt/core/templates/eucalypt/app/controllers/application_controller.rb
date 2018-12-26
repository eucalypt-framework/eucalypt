class ApplicationController < Sinatra::Base
  helpers ApplicationHelper if defined? ApplicationHelper

  maintenance do
    static '/maintenance.html'
  end

  get '/' do
    erb :index
  end
end