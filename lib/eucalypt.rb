require 'eucalypt/version'
require 'eucalypt/eucalypt-core/cli/core'
require 'eucalypt/blog/namespaces/blog/cli/blog'
require 'eucalypt/eucalypt-generate/namespaces/generate/cli/generate'
require 'eucalypt/eucalypt-destroy/namespaces/destroy/cli/destroy'
require 'eucalypt/eucalypt-security/namespaces/security/cli/security'
require 'eucalypt/eucalypt-migration/namespaces/migration/cli/migration'
require 'eucalypt/static'
require 'eucalypt/controller'
require 'eucalypt/app'
require 'eucalypt/root'

module Eucalypt
  class CLI < Thor
    class << self
      require 'eucalypt/list'
      include Eucalypt::List
    end
  end
end