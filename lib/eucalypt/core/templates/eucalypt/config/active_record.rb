class ApplicationController < Sinatra::Base
  # Comment or remove the below lines for no logging
  ActiveRecord::Base.logger = Logger.new STDOUT
  ActiveRecord::Migration.verbose = true
end