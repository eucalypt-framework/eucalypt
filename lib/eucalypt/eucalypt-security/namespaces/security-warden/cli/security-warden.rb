require 'thor'
require 'eucalypt/eucalypt-security/helpers'
require 'active_record'
module Eucalypt
  class SecurityWarden < Thor
    include Thor::Actions
    include Eucalypt::Security::Helpers

    def self.source_root
      File.join File.dirname(__dir__), 'templates'
    end

    desc "setup", "Set up Warden authentication"
    def setup
      directory = File.expand_path ?.
      puts "\n\e[94;4mSetting up Warden authentication...\e[0m"
      if File.exist? File.join(directory, '.eucalypt')
        # Add Warden and BCrypt to Gemfile
        add_to_gemfile(
          'Authentication and encryption',
          {warden: '~> 1.2', bcrypt: '~> 3.1'},
          directory
        )
        # Create Warden config file
        create_config_file(:warden, directory)
        # Create user migration if it doesn't exist
        sleep 1
        create_users_migration_file(directory)
        # Create user model if it doesn't exist
        create_user_model(directory)

        puts "\e[1mINFO\e[0m: Ensure you run `\e[1mrake db:migrate\e[0m` to create the necessary tables for Warden."
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} security #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end
  end
end