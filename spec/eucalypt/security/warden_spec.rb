require 'spec_helper'

describe Eucalypt do
  describe SecurityWarden do
    describe 'Setup' do
      subject do
        {
          model: File.join('app', 'models', 'user.rb'),
          controller: File.join('app', 'controllers', 'authentication_controller.rb'),
          login_view: File.join('app', 'views', 'authentication', 'login.erb'),
          config: File.join('config', 'warden.rb')
        }
      end

      context 'no flags' do
        before :all do
          Temporary.create_app
          tmp { execute 'security warden setup --no-controller' }
          @migration = tmp { find_migration 'create_users' }
        end
        after(:all) { Temporary.clear }

        it 'should set up an authentication environment' do
          expect(tmp { Helpers::Gemfile.include? %w[warden bcrypt], '.' }).to be true
        end

        it 'should create a Sinatra config file' do
          expect(tmp { File.file? subject[:config] }).to be true
        end

        it 'should create a User model' do
          expect(tmp { File.file? subject[:model] }).to be true
        end

        it 'should create a user table creation migration' do
          expect(@migration).not_to be nil
          expect(tmp { File.file? @migration }).to be true
        end
      end
      context '--controller, -c' do
        before :all do
          Temporary.create_app
          tmp { execute 'security warden setup' }
        end
        after(:all) { Temporary.clear }

        it 'should create an authentication controller' do
          expect(tmp { File.file? subject[:controller] }).to be true
        end

        it 'should create an authentication login view' do
          expect(tmp { File.file? subject[:login_view] }).to be true
        end
      end
    end
  end
end