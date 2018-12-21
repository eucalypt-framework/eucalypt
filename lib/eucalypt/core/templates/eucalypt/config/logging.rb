require 'fileutils'
class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new
  helpers { def logger() settings.logger end }

  configure :test { disable :logging }
  configure :development { enable :logging }

  # General logging
  %i[production].each do |app_env|
    configure app_env do
      enable :logging
      use Rack::CommonLogger, $stdout

      time = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
      log_path = Eucalypt.path 'log', time.sub(/_\+/, ?p).sub(/_\-/, ?m)
      FileUtils.mkdir_p log_path

      $stderr.reopen File.new(File.join(log_path, "#{app_env}.stderr.log"), 'a+')
      $stderr.sync = true
      $stdout.reopen File.new(File.join(log_path, "#{app_env}.stdout.log"), 'a+')
      $stdout.sync = true
    end
  end

  # ActiveRecord logging
  ActiveRecord::Base.logger = Logger.new STDOUT
  ActiveRecord::Migration.verbose = true # Set to false for quieter logging
end