require 'bundler'
require 'active_support/core_ext/hash'
require 'sinatra'
Bundler.require :default, settings.environment
Eucalypt.set_root __dir__

class ApplicationController < Sinatra::Base
  # Set server
  set :server, %w[thin webrick]

  # Set core application file
  set :app_file, __FILE__

  # Set application root directory
  set :root, Eucalypt.root

  # Set public folder for static files
  set :public_folder, Eucalypt.path('app', 'static')

  # Allow static files to be served
  set :static, true
  ::Static = Eucalypt::Static.new(settings.public_folder, symbolize: true).freeze

  # Set views directory
  set :views, Eucalypt.path('app', 'views')

  # Set default ERB template
  set :erb, layout: :'layouts/main'

  # Set Hanami HTML and asset helpers
  helpers Hanami::Helpers, Hanami::Assets::Helpers
end

Eucalypt.require 'config', '*.rb'
Eucalypt.require 'config', 'initializers', '*.rb'
Eucalypt.require 'app', 'helpers', '{application_helper.rb}'
Eucalypt.require 'app', 'controllers', 'application_controller.rb'
Eucalypt.require 'app', '{models,policies,helpers,controllers}', '*.rb'