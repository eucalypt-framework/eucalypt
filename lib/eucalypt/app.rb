module Eucalypt
  APP_FILE = 'Gumfile'.freeze

  def self.app?(directory)
    File.exist? File.join(directory, APP_FILE)
  end

  # @note Does not check for boolean variables.
  #   Instead checks for presence.
  def self.console?
    !!ENV['CONSOLE']
  end
end