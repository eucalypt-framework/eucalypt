module Eucalypt
  module Error
    class << self
      def wrong_directory
        puts "\e[1;91mERROR\e[0m: Couldn't find \e[1m.eucalypt\e[0m file in current directory."
        puts "\e[1mINFO\e[0m: Try:"
        puts " - Changing the current working directory to your application's root directory."
        puts " - Creating a new application with `\e[1meucalypt init your-app-name\e[0m`."
        puts " - Creating a .eucalypt file if you deleted it."
      end

      def no_articles
        puts "\e[1;91mERROR\e[0m: Couldn't find any blog articles."
      end

      def delete_article_warning
        puts "\e[1;93mWARNING\e[0m: Deleting an article will delete both the markdown file and all assets!"
      end

      def no_mvc(mvc_file)
        puts "\e[1;91mERROR\e[0m: Couldn't find any #{mvc_file}s."
      end

      def no_scaffolds
        puts "\e[1;91mERROR\e[0m: Couldn't find any scaffolds."
      end

      def no_gems(gems, command)
        puts "\e[1;91mERROR\e[0m: Couldn't find gems #{gems} in Gemfile."
        puts "\e[1mINFO\e[0m:"
        puts " - Ensure you have run the setup command `\e[1m#{command}\e[0m`."
      end

      def no_user_model
        puts "\e[91;1mERROR\e[0m: Couldn't find a user model.\e[0m"
        puts "\e[1mINFO\e[0m:"
        puts " - Ensure you have run the setup command `\e[1meucalypt security warden setup\e[0m`."
      end

      def no_role_model
        puts "\e[91;1mERROR\e[0m: Couldn't find a role model.\e[0m"
        puts "\e[1mINFO\e[0m:"
        puts " - Ensure you have run the setup command `\e[1meucalypt security pundit setup\e[0m`."
      end

      def no_policy(policy_name)
        puts "\e[91;1mERROR\e[0m: Couldn't find a #{policy_name} role model or policy file.\e[0m"
        puts "\e[1mINFO\e[0m:"
        puts " - Ensure you have run the setup command `\e[1meucalypt security policy g #{policy_name}\e[0m`."
      end
    end
  end
end