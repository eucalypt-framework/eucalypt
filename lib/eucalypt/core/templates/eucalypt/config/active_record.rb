class ApplicationController < Sinatra::Base
  ActiveRecord::Base.logger = Logger.new STDOUT

  # Set the below assignment to false for quieter ActiveRecord logging
  ActiveRecord::Migration.verbose = true
end