require 'bundler'
Bundler.require :default
require_relative 'config/root'

Eucalypt.glob('config', 'initializers', '*.rb').each{|file| require file}

class ApplicationController < Sinatra::Base
  # Set server
  set :server, %w[thin webrick]

  # Set core application file
  set :app_file, __FILE__

  # Set application root directory
  set :root, Eucalypt::ROOT

  # Set views directory
  set :views, Eucalypt.path('app', 'views')

  # Set default ERB template
  set :erb, layout: :'layouts/main'

  # Set Hanami asset helpers
  helpers Hanami::Helpers, Hanami::Assets::Helpers
end

Eucalypt.glob('config', '*.rb').each{|file| require file}

require Eucalypt.path('config', 'sinatra', 'logging')
Eucalypt.glob('config', 'sinatra', '*.rb').each{|file| require file}

if File.file?(file = Eucalypt.path('app', 'helpers', 'application_helper.rb'))
  require file
end
require Eucalypt.path('app', 'controllers', 'application_controller')
Eucalypt.glob('app', '{models,policies,helpers,controllers}', '*.rb').each{|file| require file}