require 'sinatra'
class ApplicationController < Sinatra::Base; end
module Eucalypt
  def self.Controller(route:)
    name = File.basename(caller[0][/[^:]+/],'.*').camelize
    Object.const_set name, Class.new(::ApplicationController)
    name.constantize.instance_eval %{def router() "#{route}" end}
    ::ApplicationController
  end
end