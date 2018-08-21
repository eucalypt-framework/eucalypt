class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new

  configure :production do
    require 'fileutils'
    use Rack::CommonLogger, $stdout

    log_path = Eucalypt.path 'log', Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/, ?p).sub(/_\-/, ?m)
    FileUtils.mkdir_p log_path

    # STDERR logger
    stderr_log = File.new File.join(log_path, 'stderr.log'), 'a+'
    $stderr.reopen stderr_log
    $stderr.sync = true

    # STDOUT logger
    stdout_log = File.new File.join(log_path, 'stdout.log'), 'a+'
    $stdout.reopen stdout_log
    $stdout.sync = true
  end

  helpers do
    def logger
      settings.logger
    end
  end
end