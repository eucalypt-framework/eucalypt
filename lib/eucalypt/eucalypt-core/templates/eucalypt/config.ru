require_relative 'app'

Eucalypt.glob('app', 'controllers', '*.rb').each do |file|
  controller_name = File.basename(file,'.*').camelize
  next if controller_name == 'ApplicationController'
  controller = controller_name.constantize
  map(controller.router) { run controller }
end

map('/') { run ApplicationController }