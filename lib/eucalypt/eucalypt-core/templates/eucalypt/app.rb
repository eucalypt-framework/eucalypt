require 'bundler'
Bundler.require :default

Eucalypt::ROOT = __dir__.freeze

module Eucalypt
  class << self
    def root() ROOT end
    def path(*args) File.join(ROOT, *args) end
    def glob(*args, &block) Dir.glob(self.path(*args), &block) end
  end
end

Eucalypt.glob 'config', 'initializers', '*.rb', &method(:require)

Static = Eucalypt::Static.new(Eucalypt.path('app', 'structured'), symbolize: true).freeze

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

  # Set Hanami asset helpers
  helpers Hanami::Helpers, Hanami::Assets::Helpers
end

require Eucalypt.path 'config', 'logging'
Eucalypt.glob 'config', '*.rb', &method(:require)
Eucalypt.glob 'app', 'helpers', '{application_helper.rb}', &method(:require)
require Eucalypt.path 'app', 'controllers', 'application_controller'
Eucalypt.glob 'app', '{models,policies,helpers,controllers}', '*.rb', &method(:require)