module Eucalypt
  APP_FILE = '.eucalypt'

  def self.app?(directory)
    File.exist? File.join(directory, APP_FILE)
  end
end