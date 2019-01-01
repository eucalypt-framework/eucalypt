require 'bundler'
require 'active_support/core_ext/hash'
require 'sinatra'
Bundler.require :default, settings.environment
Eucalypt.set_root __dir__

class ApplicationController < Sinatra::Base
  # Set core application file
  set :app_file, __FILE__

  # Set public folder for static files
  set :public_folder, Eucalypt.path('app', 'static', 'public')

  # Set static data accessor
  ::Static = Eucalypt::Static.new(Eucalypt.path('app', 'static'), symbolize: true).freeze

  # Set views directory
  set :views, Eucalypt.path('app', 'views')

  # Set default ERB template
  set :erb, layout: :'layouts/main'

  # Set IP whitelist
  set :whitelist, Eucalypt::Whitelist.new(Eucalypt.path 'config', 'whitelist')

  # Toggle maintenance mode
  disable :maintenance

  # Set Hanami HTML and asset helpers
  helpers Hanami::Helpers, Hanami::Assets::Helpers

  require 'eucalypt/load'
end