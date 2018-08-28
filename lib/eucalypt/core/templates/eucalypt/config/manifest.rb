class ApplicationController < Sinatra::Base
  # Application manifest file accessor method
  helpers do
    def application(*args)
      html = String.new
      args.map(&:to_sym).each do |arg|
        html << stylesheet('application') if %i[css stylesheet].include? arg
        html << javascript('application') if %i[js javascript].include? arg
      end
      html
    rescue
      raise ArgumentError.new "Expected arguments to be any of: #{css+js}"
    end
  end
end