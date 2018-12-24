class ApplicationController < Sinatra::Base
  LOGGER = if (settings.logging == !!settings.logging)
    Lumberjack::Logger.new $stdout
  else
    Lumberjack::Logger.new $stdout, level: settings.logging
  end

  set :logger, LOGGER

  class DummyLogger
    def initialize(silence = false, stdout = nil)
      @silence = silence
      @stdout = stdout
    end

    def method_missing(m, *args, &block)
      LOGGER.send(m, *args, &block)
      $stdout.reopen(@stdout) if @silence
    end
  end

  helpers do
    def logger()
      if settings.logging
        return DummyLogger.new
      else
        stdout = $stdout.clone
        $stdout.reopen IO::NULL
        return DummyLogger.new(true, stdout)
      end
    end
  end

  private_constant :DummyLogger

  if settings.log_file
    time = Time.now.strftime settings.log_directory_format # Sanitize time!
    path = Eucalypt.path('log', time)

    require 'fileutils'
    FileUtils.mkdir_p path

    $stderr.reopen File.new(File.join(path, "#{settings.environment}.stderr.log"), 'a+')
    $stderr.sync = true
    $stdout.reopen File.new(File.join(path, "#{settings.environment}.stdout.log"), 'a+')
    $stdout.sync = true
  end
end