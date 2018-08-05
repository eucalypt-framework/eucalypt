require_relative 'colorize'
module Eucalypt
  module Helpers
    module Messages
      module Out
        METHODS = {
          warning: [:bold, :yellow],
          error: [:bold, :red],
          info: [:bold]
        }

        class << self
          METHODS.each do |method, opts|
            define_method "#{method}_message" do |message = String.new|
              "#{method.to_s.upcase.colorize(*opts)}: #{message}"
            end

            define_method method do |message = String.new|
              puts self.send("#{method}_message", message)
            end
          end

          def setup(message = String.new)
            puts "\n#{message.colorize(:underline, :blue)}"
          end
        end
      end
    end
  end
end
include Eucalypt::Helpers::Messages