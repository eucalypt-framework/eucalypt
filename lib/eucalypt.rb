require 'eucalypt/version'
require 'eucalypt/core/cli/core'
require 'eucalypt/blog/namespaces/blog/cli/blog'
require 'eucalypt/generate/namespaces/generate/cli/generate'
require 'eucalypt/destroy/namespaces/destroy/cli/destroy'
require 'eucalypt/security/namespaces/security/cli/security'
require 'eucalypt/migration/namespaces/migration/cli/migration'
require 'eucalypt/static'
require 'eucalypt/controller'
require 'eucalypt/app'
require 'eucalypt/root'
require 'eucalypt/list'
require 'eucalypt/core/helpers/manifest'
require 'eucalypt/core/helpers/partial'
require 'eucalypt/guard'

Eucalypt::CLI.extend Eucalypt::List

class ApplicationController < Sinatra::Base; end
def app() ApplicationController end