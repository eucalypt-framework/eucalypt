class ApplicationController < Sinatra::Base
  # Application manifest file accessor method
  helpers do
    def application(*args)
      html = String.new
      css = %i[css stylesheet]
      js = %i[js javascript]
      args.map(&:to_sym).each do |arg|
        html << stylesheet('application') if css.include? arg
        html << javascript('application') if js.include? arg
      end
      html
    rescue
      raise ArgumentError.new("Expected arguments to be any of: #{css+js}")
    end
  end
end