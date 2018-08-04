module Eucalypt
  # Specifies the root directory of the application (don't change this!)
  ROOT = File.dirname __dir__
  def self.root() ROOT end
  def self.path(*args) File.join(ROOT, *args) end
  def self.glob(*args) Dir[self.path(*args)] end
  def self.entries(*args) Dir.entries(self.path(*args)) end
end