require 'sinatra'
class ApplicationController < Sinatra::Base
  def static(uri, *args)
    if env['HTTP_VERSION'] == 'HTTP/1.1' and env["REQUEST_METHOD"] != 'GET'
      status 303
    else
      status 302
    end

    # According to RFC 2616 section 14.30, "the field value consists of a
    # single absolute URI"
    response['Location'] = uri(uri.to_s, settings.absolute_redirects?, settings.prefixed_redirects?)
    halt(*args)
  end
end