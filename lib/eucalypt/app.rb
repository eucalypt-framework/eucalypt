module Eucalypt
  APP_FILE = 'Gumfile'.freeze

  def self.app?(directory)
    File.exist? File.join(directory, APP_FILE)
  end

  def self.console?
    !!ENV['CONSOLE']
  end
end