class ApplicationController < Sinatra::Base
  set :assets, Sprockets::Environment.new

  assets.css_compressor = :scss
  assets.js_compressor = :uglify

  Eucalypt.glob 'app', 'assets', '*' do |item|
    assets.append_path item if File.directory? item
  end

  get '/assets/*' do
    env["PATH_INFO"].sub! '/assets', ''
    settings.assets.call env
  end
end