require 'eucalypt/helpers/messages'
require 'eucalypt/helpers/app'

module Eucalypt
  module Error
    include Eucalypt::Helpers::Messages
    class << self
      def wrong_directory
        puts
        Out.error "Couldn't find #{Eucalypt::APP_FILE.colorize(:bold)} in current directory."
        Out.info 'Try:'
        puts " - Changing the current working directory to your application's root directory."
        puts " - Creating a new application with `#{'eucalypt init your-app-name'.colorize(:bold)}`."
        puts " - Creating a #{Eucalypt::APP_FILE.colorize(:bold)} if you deleted it."
      end

      def found_app_file
        Out.warning "Found #{Eucalypt::APP_FILE.colorize(:bold)} in the current directory."
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
        Out.info
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_user_model
        Out.error "Couldn't find a user model."
        Out.info
        command = 'eucalypt security warden setup'
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_role_model
        Out.error "Couldn't find a role model."
        Out.info
        command = 'eucalypt security pundit setup'
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end

      def no_policy(policy_name)
        Out.error "Couldn't find a #{policy_name} role model or policy file."
        Out.info
        command = "eucalypt security policy g #{policy_name}"
        puts " - Ensure you have run the setup command `#{command.colorize(:bold)}`."
      end
    end
  end
end