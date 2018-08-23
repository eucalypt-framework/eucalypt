class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new

  require 'fileutils'
  %i[production test] do |environment|
    configure environment do
      use Rack::CommonLogger, $stdout

      log_path = Eucalypt.path 'log', Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/, ?p).sub(/_\-/, ?m)
      FileUtils.mkdir_p log_path

      # STDERR logger
      stderr_log = File.new File.join(log_path, "#{settings.environment}.stderr.log"), 'a+'
      $stderr.reopen stderr_log
      $stderr.sync = true

      # STDOUT logger
      stdout_log = File.new File.join(log_path, "#{settings.environment}.stdout.log"), 'a+'
      $stdout.reopen stdout_log
      $stdout.sync = true
    end
  end

  helpers do
    def logger
      settings.logger
    end
  end
end