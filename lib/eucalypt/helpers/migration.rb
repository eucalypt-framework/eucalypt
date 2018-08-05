require 'thor'
require_relative 'messages'

module Eucalypt
  module Helpers
    class Migration < Thor
      include Thor::Actions
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

      private

      def create_anyway_prompt
        ask Out.warning_message("A #{@title.colorize(:bold)} migration already exists. Create anyway?"), limited_to: %w[y Y Yes YES n N No NO]
      end
    end
  end
end