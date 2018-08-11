require 'eucalypt/app'
require 'eucalypt/helpers'
require 'string/builder'

module Eucalypt
  module Error
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    using String::Builder
    using Colorize

    class << self
      def wrong_directory
        puts
        Out.error "Couldn't find #{Eucalypt::APP_FILE.colorize(:bold)} in current directory."
        puts
        Out.info 'Try:'
        puts " - Changing the current working directory to your application's root directory."
        puts " - Creating a new application with `#{'eucalypt init'.colorize(:bold)}`."
        puts " - Creating a #{Eucalypt::APP_FILE.colorize(:bold)} if you deleted it."
      end

      def found_app_file
        Out.warning "Found #{Eucalypt::APP_FILE.colorize(:bold)} in the current directory."
        puts
        Out.info
        puts " - The current directory might already be a Eucalypt application."
        puts " - Proceeding with the initialization will create a new nested application."
        puts " - This shouldn't be a problem, but is it really what you intended?"
        puts
      end

      def no_articles
        Out.error "Couldn't find any blog articles"
      end

      def delete_article_warning
        Out.warning 'Deleting an article will delete both the markdown file and all assets!'
      end

      def no_mvc(mvc_file)
        Out.error "Couldn't find any #{mvc_file}s"
      end

      def no_scaffolds
        Out.error "Couldn't find any scaffolds."
      end

      def no_gems(gems, command)
        Out.error "Couldn't find gems #{gems} in Gemfile."
        puts
        Out.info
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_user_model
        Out.error "Couldn't find a user model."
        puts
        Out.info
        command = 'eucalypt security warden setup'
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_role_model
        Out.error "Couldn't find a role model."
        puts
        Out.info
        command = 'eucalypt security pundit setup'
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_policy(policy_name)
        Out.error "Couldn't find a #{policy_name} role model or policy file."
        puts
        Out.info
        command = "eucalypt security policy g #{policy_name}"
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def invalid_columns(invalid_declarations, invalid_types)
        puts if invalid_declarations.any? || invalid_types.any?
        if invalid_declarations.any?
          Out.error "Invalid column declaration(s): #{invalid_declarations.inspect}"
          Out.info "Column declarations should match the regex: #{Eucalypt::Helpers::Migration::Validation::DECLARATION_REGEX.inspect}"
          puts " - Examples: name:string, price:decimal, elo:primary_key"
        end
        if invalid_types.any?
          output = String.build "Invalid column type(s): " do |s|
            invalid_types.each_with_index do |obj, i|
              type, column = obj[:type], obj[:column]
              s << "#{column}:#{type.colorize(:bold)}"
              s << ', ' unless i == invalid_types.size-1
            end
          end
          puts if invalid_declarations.any? && invalid_types.any?
          Out.error output
          Out.info "To list all permitted column types, run the command `#{"eucalypt migration types".colorize(:bold)}`"
        end
      end

      def invalid_type(type)
        puts
        Out.error "Invalid column type: #{type.colorize(:bold)}"
        Out.info "To list all permitted column types, run the command `#{"eucalypt migration types".colorize(:bold)}`"
      end
    end
  end
end