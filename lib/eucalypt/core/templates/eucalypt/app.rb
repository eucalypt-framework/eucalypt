require 'bundler'
Bundler.require :default
Eucalypt.set_root __dir__

Static = Eucalypt::Static.new(Eucalypt.path('app', 'static'), symbolize: true).freeze

class ApplicationController < Sinatra::Base
  # Set server
  set :server, %w[thin webrick]

  # Set core application file
  set :app_file, __FILE__

  # Set application root directory
  set :root, Eucalypt.root

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