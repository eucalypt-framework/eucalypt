class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new

  require 'fileutils'
  %i[production test].each do |e|
    configure e do
      use Rack::CommonLogger, $stdout

      log_path = Eucalypt.path 'log', Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/, ?p).sub(/_\-/, ?m)
      FileUtils.mkdir_p log_path

      # STDERR logger
      $stderr.reopen File.new(File.join(log_path, "#{e}.stderr.log"), 'a+')
      $stderr.sync = true

      # STDOUT logger
      $stdout.reopen File.new(File.join(log_path, "#{e}.stdout.log"), 'a+')
      $stdout.sync = true
    end
  end

  helpers do
    def logger
      settings.logger
    end
  end
end