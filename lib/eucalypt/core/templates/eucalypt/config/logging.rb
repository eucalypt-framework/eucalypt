require 'fileutils'
class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new
  helpers { def logger() settings.logger end }

  #= General logging =#
  %i[production test].each do |e|
    configure e do
      use Rack::CommonLogger, $stdout

      log_path = Eucalypt.path 'log', Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/, ?p).sub(/_\-/, ?m)
      FileUtils.mkdir_p log_path

      $stderr.reopen File.new(File.join(log_path, "#{e}.stderr.log"), 'a+')
      $stderr.sync = true
      $stdout.reopen File.new(File.join(log_path, "#{e}.stdout.log"), 'a+')
      $stdout.sync = true
    end
  end

  #= ActiveRecord logging =#
  ActiveRecord::Base.logger = Logger.new STDOUT
  ActiveRecord::Migration.verbose = true # Set to false for quieter logging
end