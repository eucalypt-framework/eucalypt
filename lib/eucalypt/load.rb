Eucalypt.require 'config', '*.rb'
Eucalypt.require 'config', 'initializers', '*.rb'

require 'eucalypt/core/helpers/maintenance'

Eucalypt.require 'app', 'helpers', '{application_helper.rb}'
Eucalypt.require 'app', 'controllers', 'application_controller.rb'
Eucalypt.require 'app', '{models,policies,helpers,controllers}', '*.rb'