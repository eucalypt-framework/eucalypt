require 'active_support'
require 'active_support/core_ext'
require 'thor'
require 'eucalypt/helpers'

module Eucalypt
  module Generators
    class AuthController < Thor::Group
      include Thor::Actions
      include Eucalypt::Helpers
      using String::Builder

      def self.source_root
        File.join File.dirname(__dir__), 'templates'
      end

      def generate
        template 'auth_controller.tt', File.join('app', 'controllers', 'authentication_controller.rb')

        config = {}
        config[:data] = String.build do |s|
          s << "<%=\n"
          s << "  form_for :user, '/auth/login' do\n"
          s << "    text_field :username\n"
          s << "    password_field :password\n"
          s << "    submit 'Login'\n"
          s << "  end\n"
          s << "%>"
        end
        template 'auth_login.tt', File.join('app', 'views', 'authentication', 'login.erb'), config
      end
    end
  end
end