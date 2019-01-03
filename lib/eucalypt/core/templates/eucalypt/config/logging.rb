class ApplicationController < Sinatra::Base
  configure :test do
    disable :logging
    disable :log_file
  end

  configure :development do
    set :logging, Lumberjack::Severity::DEBUG
    disable :log_file
  end

  configure :production do
    enable :logging
    enable :log_file
  end

  set :log_directory_format, "%Y-%m-%d_%H-%M-%S"

  require 'eucalypt/core/helpers/logging'

  # ActiveRecord logging
  ActiveRecord::Base.logger = Logger.new STDOUT
  ActiveRecord::Migration.verbose = false
end