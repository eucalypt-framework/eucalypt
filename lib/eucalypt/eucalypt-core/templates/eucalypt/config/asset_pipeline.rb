class ApplicationController < Sinatra::Base
  set :assets, Sprockets::Environment.new
  assets.append_path Eucalypt.path 'app', 'assets', 'stylesheets'
  assets.append_path Eucalypt.path 'app', 'assets', 'scripts'
  assets.append_path Eucalypt.path 'app', 'assets', 'images'
  assets.append_path Eucalypt.path 'app', 'assets', 'fonts'

  assets.css_compressor = :scss
  assets.js_compressor = :uglify

  get '/assets/*' do
    env["PATH_INFO"].sub! '/assets', ''
    settings.assets.call env
  end
end