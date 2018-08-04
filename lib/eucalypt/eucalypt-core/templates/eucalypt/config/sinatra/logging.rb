class ApplicationController < Sinatra::Base
  # Set logger variables
  configure(:development) { set :logger, Lumberjack::Logger.new }
  configure(:test) { set :logger, Lumberjack::Logger.new }
  configure :production do
    log_name = Time.now.strftime("server-start_%Y-%m-%dT%H-%M-%S_%z").sub(/_\+/,'_p').sub(/_\-/,'_m')
    log_file_path = Eucalypt.path('log', "#{log_name}.log")
    set :logger, Lumberjack::Logger.new
    use Rack::CommonLogger, $stdout
    log = File.new(log_file_path, "a+")
    $stdout.reopen(log)
    $stderr.reopen(log)
    $stderr.sync = true
    $stdout.sync = true
  end

  helpers do
    define_method(:l) { settings.logger }
  end
end