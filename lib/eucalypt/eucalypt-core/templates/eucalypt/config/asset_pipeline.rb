class ApplicationController < Sinatra::Base
  set :environment, Sprockets::Environment.new
  environment.append_path Eucalypt.path 'app', 'assets', 'stylesheets'
  environment.append_path Eucalypt.path 'app', 'assets', 'scripts'
  environment.append_path Eucalypt.path 'app', 'assets', 'images'
  environment.append_path Eucalypt.path 'app', 'assets', 'fonts'

  environment.css_compressor = :scss
  environment.js_compressor = :uglify

  get '/assets/*' do
    env["PATH_INFO"].sub! '/assets', ''
    settings.environment.call env
  end
end