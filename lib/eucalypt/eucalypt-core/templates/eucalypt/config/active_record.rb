class ApplicationController < Sinatra::Base
  # Set ActiveRecord verbosity (comment or remove for no logging)
  # Comment or remove the below lines for no logging
  ActiveRecord::Base.logger = Logger.new STDOUT
  ActiveRecord::Migration.verbose = true
end