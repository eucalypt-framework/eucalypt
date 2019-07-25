class MainController < ApplicationController; end

require 'eucalypt/core/helpers/assets'
Eucalypt.require 'config', '*.rb'
Eucalypt.require 'config', 'initializers', '*.rb'

require 'eucalypt/core/helpers/static'
Eucalypt.require 'app', 'helpers', '{application_helper.rb}'
ApplicationController.helpers ApplicationHelper if defined? ApplicationHelper

Eucalypt.require 'app', 'helpers', '{main_helper.rb}'
Eucalypt.require 'app', 'controllers', 'main_controller.rb'
Eucalypt.require 'app', '{models,helpers,controllers}', '*.rb'

require 'eucalypt/core/helpers/default_index'
require 'eucalypt/core/helpers/maintenance'