require 'fileutils'
class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new
  helpers { def logger() settings.logger end }

  # General logging
  %i[production test].each do |app_env|
    configure app_env do
      use Rack::CommonLogger, $stdout

      time = Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z")
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