class ApplicationController < Sinatra::Base
  assets.css_compressor = :scss
  assets.js_compressor = :uglify
end