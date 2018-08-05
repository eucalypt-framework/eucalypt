require 'eucalypt/helpers/messages'

module Eucalypt
  module Error
    include Eucalypt::Helpers::Messages
    class << self
      def wrong_directory
        Out.error "Couldn't find #{'.eucalypt'.colorize(:bold)} file in current directory."
        Out.info 'Try:'
        puts " - Changing the current working directory to your application's root directory."
        puts " - Creating a new application with `#{'eucalypt init your-app-name'.colorize(:bold)}`."
        puts " - Creating a .eucalypt file if you deleted it."
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