class ApplicationController < Sinatra::Base
  helpers ApplicationHelper if defined? ApplicationHelper

  static do |s|
    s.route '/maintenance.html', aliases: %w[/maintenance]
    s.route '/robots.txt'
  end

  maintenance do
    redirect '/maintenance'
  end

  get '/' do
    erb :index
  end
end