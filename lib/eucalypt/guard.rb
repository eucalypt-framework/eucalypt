class ApplicationController < Sinatra::Base
  helpers do
    def guard
      settings.guard
    end
  end
end