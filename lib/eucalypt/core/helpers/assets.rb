class ApplicationController < Sinatra::Base
  set :assets, Sprockets::Environment.new

  Eucalypt.glob 'app', 'assets', '*' do |item|
    assets.append_path item if File.directory? item
  end

  MainController.get '/assets/*' do
    env["PATH_INFO"].sub! '/assets', ''
    settings.assets.call env
  end
end