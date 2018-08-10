require 'eucalypt/helpers/numeric'
require 'eucalypt/helpers/inflect'
require 'thor'
module Eucalypt
  class Migration < Thor
    module Helpers
      include Eucalypt::Helpers

      def sanitize_table_options(options) # primary_key id temporary force
        sanitized_options = []
        options.keys.each do |option|
          value = options[option]
          option = option.to_sym

          case option
          when :primary_key
            next unless /\A[^,]+(,[^,]+)*\Z/.match? value
            opts = value.split(?,).map{|v| Inflect.resource_keep_inflection(v)}
            opts.reject! &:empty?
            next if opts.empty?
            sanitize_options << (opts.size == 1 ? [option, ":#{opts.first}"] : [option, "%i[#{(opts.map {|v| "#{v}"}*' ')}]"])
          when :id
            id = Inflect.resource_keep_inflection(value)
            next if id.empty?
            sanitized_options << (%w[true false].include?(id) ? [option, id] : [option, ":#{id}"])
          when :temporary
            sanitized_options << [option, value] if %w[true false].include? value
          when :force
            sanitized_options << [option, ":#{value}"] if value == 'cascade'
            sanitized_options << [option, value] if %w[true false].include? value
          end
        end
        sanitized_options
      end

      def sanitize_index_options(options) # unique length where using type
        sanitized_options = []
        options.keys.each do |option|
          value = options[option]
          option = option.to_sym

          case option
          when :unique
            sanitized_options << [option, value] if %w[true false].include? value
          when :length
            sanitized_options << [option, value] if Eucalypt::Helpers::Numeric.string? value
          when :where
            partial = Inflect.resource_keep_inflection(value)
            next if partial.empty?
            sanitized_options << [option, ":#{partial}"]
          when :using
            method = Inflect.resource_keep_inflection(value)
            next if method.empty?
            sanitized_options << [option, ":#{method}"]
          when :type
            type = Inflect.resource_keep_inflection(value)
            next if type.empty?
            sanitized_options << [option, ":#{type}"]
          end
        end
        sanitized_options
      end

      def sanitize_column_options(options)
        sanitized_options = []
        options.keys.each do |option|
          value = options[option]
          option = option.to_sym

          case option
          when :limit
            sanitized_options << [option, value] if Eucalypt::Helpers::Numeric.string? value
          when :default
            if %w[nil null].include? value
              sanitized_options << [option, 'nil']
            elsif Eucalypt::Helpers::Numeric.string? value
              sanitized_options << [option, value]
            else
              sanitized_options << [option, "\'#{value}\'"]
            end
          when :null
            sanitized_options << [option, value] if %w[true false].include? value
          when :precision
            sanitized_options << [option, value] if Eucalypt::Helpers::Numeric.string? value
          when :scale
            sanitized_options << [option, value] if Eucalypt::Helpers::Numeric.string? value
          end
        end
        sanitized_options
      end
    end
  end
end