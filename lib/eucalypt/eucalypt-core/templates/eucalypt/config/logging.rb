class ApplicationController < Sinatra::Base
  set :logger, Lumberjack::Logger.new

  configure :production do
    use Rack::CommonLogger, $stdout

    log_name = Time.now.strftime("%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/,'_p').sub(/_\-/,'_m')

    # STDERR logger
    stderr_log = File.new Eucalypt.path('log', "#{log_name}.stderr.log"), 'a+'
    $stderr.reopen stderr_log
    $stderr.sync = true

    # STDOUT logger
    stdout_log = File.new Eucalypt.path('log', "#{log_name}.stdout.log"), 'a+'
    $stdout.reopen stdout_log
    $stdout.sync = true
  end

  helpers do
    def logger
      settings.logger
    end
  end
end