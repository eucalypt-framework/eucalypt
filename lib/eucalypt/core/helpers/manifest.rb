require 'sinatra'
class ApplicationController < Sinatra::Base
  # Application manifest file accessor method
  helpers do
    def manifest(*args)
      html = String.new
      args.map(&:to_sym).each do |arg|
        html << %{<link href="/assets/application.css" type="text/css" rel="stylesheet">} if arg == :stylesheet
        html << %{<script src="/assets/application.js" type="text/javascript"></script>} if arg == :script
      end
      html
    rescue
      raise ArgumentError.new "Expected arguments to be any of: [stylesheet, script]"
    end
  end
end