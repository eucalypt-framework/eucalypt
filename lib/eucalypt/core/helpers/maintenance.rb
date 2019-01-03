class ApplicationController < Sinatra::Base
  def self.maintenance(enabled:, &block)
    if enabled
      MainController.get '/maintenance', &block
      Eucalypt.glob('app', 'controllers', '*.rb') do |file|
        controller = File.basename(file,'.*').camelize.constantize
        controller.before '*' do
          splat = params[:splat].reject {|param| /\/assets\/.*/.match? param}
          redirect '/maintenance' unless splat.include?('/maintenance') || splat.empty?
        end
      end
    end
  end
end