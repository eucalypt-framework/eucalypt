class MainController < ApplicationController; end

Eucalypt.require 'config', '*.rb'
Eucalypt.require 'config', 'initializers', '*.rb'

Eucalypt.require 'app', 'helpers', '{application_helper.rb}'
ApplicationController.helpers ApplicationHelper if defined? ApplicationHelper

Eucalypt.require 'app', 'helpers', '{main_helper.rb}'
Eucalypt.require 'app', 'controllers', 'main_controller.rb'
Eucalypt.require 'app', '{models}', '{roles}', '*.rb'
Eucalypt.require 'app', '{models,policies,helpers,controllers}', '*.rb'

require 'eucalypt/core/helpers/static'
require 'eucalypt/security/permissions'
require 'eucalypt/core/helpers/default_index'
require 'eucalypt/core/helpers/maintenance'