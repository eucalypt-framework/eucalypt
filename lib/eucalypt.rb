require 'eucalypt/version'
require 'eucalypt/eucalypt-core/cli/core'
require 'eucalypt/eucalypt-blog/namespaces/blog/cli/blog'
require 'eucalypt/eucalypt-generate/namespaces/generate/cli/generate'
require 'eucalypt/eucalypt-destroy/namespaces/destroy/cli/destroy'
require 'eucalypt/eucalypt-security/namespaces/security/cli/security'
require 'eucalypt/eucalypt-migration/namespaces/migration/cli/migration'
require 'eucalypt/list'

module Eucalypt
  class CLI < Thor
    class << self
      include Eucalypt::List
    end
  end
end