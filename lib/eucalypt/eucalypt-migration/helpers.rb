require 'eucalypt/helpers/numeric'
require 'thor'
module Eucalypt
  class Migration < Thor
    module Helpers
      def sanitize_options(options, type: :string)
        sanitized_options = []
        options.each do |k,v|
          if %w[true false].include? v
            sanitized_options << [k,v]
          elsif Eucalypt::Helpers::Numeric.string? v
            sanitized_options << [k,v]
          else
            case type
            when :symbol then sanitized_options << [k,":#{v}"]
            when :string then sanitized_options << [k,"\'#{v}\'"]
            end
          end
        end
        sanitized_options
      end
    end
  end
end