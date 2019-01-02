class MainController < ApplicationController
  helpers MainHelper if defined? MainHelper

  static '/maintenance.html', aliases: %w[/maintenance]

  maintenance do
    redirect '/maintenance'
  end

  get '/' do
    erb :index
  end
end