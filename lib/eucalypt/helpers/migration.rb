require 'thor'
require_relative 'messages'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  module Helpers
    class Migration < Thor
      include Thor::Actions
      include Eucalypt::Helpers
      include Eucalypt::Helpers::Messages
      using Colorize
      attr_reader :title, :template, :file, :base, :file_path

      class << self
        alias_method :[], :new
      end

      no_tasks do
        def initialize(title:, template:)
          @title = title
          @template = template
          @file = Time.now.utc.strftime("%Y%m%d%H%M%S_#{title}.rb")
          @base = File.join 'db', 'migrate'
          @file_path = File.join @base, @file
        end

        def exists?
          Dir[File.join @base, '*.rb'].any? {|f| f.include? @title}
        end

        def create_anyway?
          %w[y Y Yes YES].include? create_anyway_prompt
        end
      end

      class Validation
        attr_reader :invalid_declarations, :invalid_types

        COLUMN_TYPES = %i[
          binary boolean date datetime decimal float integer
          bigint primary_key references string text time timestamp
        ]

        DECLARATION_REGEX = /\A[A-Za-z0-9_]+\:[a-z_]+\Z/

        def initialize(columns)
          @invalid_declarations = []
          @invalid_types = []

          columns.each do |column|
            if self.class.valid_declaration? column
              col, type = column.split ?:
              @invalid_types << {column: col, type: type} unless COLUMN_TYPES.include? type.to_sym
            else
              @invalid_declarations << column
            end
          end
        end

        def any_invalid?
          any_invalid = @invalid_declarations.any? || @invalid_types.any?
          Eucalypt::Error.invalid_columns(@invalid_declarations, @invalid_types) if any_invalid
          return any_invalid
        end

        def self.valid_declaration?(column)
          DECLARATION_REGEX.match? column
        end

        def self.valid_type?(type)
          valid_type = COLUMN_TYPES.include? type.to_sym
          Eucalypt::Error.invalid_type(type) unless valid_type
          return valid_type
        end
      end

      private

      def create_anyway_prompt
        ask Out.warning_message("A #{@title.colorize(:bold)} migration already exists. Create anyway?"), limited_to: %w[y Y Yes YES n N No NO]
      end
    end
  end
end