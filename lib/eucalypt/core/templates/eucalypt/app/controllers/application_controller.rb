class ApplicationController < Sinatra::Base
  helpers ApplicationHelper if defined? ApplicationHelper

  static '/maintenance.html', aliases: %w[/maintenance]

  maintenance do
    redirect '/maintenance'
  end

  get '/' do
    erb :index
  end
end