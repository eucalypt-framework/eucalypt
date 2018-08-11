require 'stringio'
def silence
  $stdout = temp_out = StringIO.new
  yield
  temp_out.string.uncolorize
ensure
  $stdout = STDOUT
end