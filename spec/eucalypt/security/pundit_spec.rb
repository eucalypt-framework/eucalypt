require 'spec_helper'

describe Eucalypt do
  describe SecurityPundit do
    context 'Setup' do
      subject do
        {
          user_model: File.join('app', 'models', 'user.rb'),
          role_model: File.join('app', 'models', 'role.rb'),
          config: File.join('config', 'pundit.rb')
        }
      end

      before :all do
        Temporary.create_app
        tmp do
          execute_many do |t|
            t << 'security warden setup --no-controller'
            t << 'security pundit setup'
          end
        end
        @migration = tmp { find_migration 'create_roles' }
      end
      after(:all) { Temporary.clear }

      it 'should set up an authorization environment' do
        expect(tmp { Helpers::Gemfile.include? %w[pundit], '.' }).to be true
      end

      it 'should create a Sinatra config file' do
        expect(tmp { File.file? subject[:config] }).to be true
      end

      it 'should create a roles table creation migration' do
        expect(@migration).not_to be nil
        expect(tmp { File.file? @migration }).to be true
      end

      it 'should add relationship to the Role model' do
        contents = tmp { File.open subject[:role_model], &:read }
        expect(contents).to include "belongs_to :user"
      end

      context 'should add relationship to User model' do
        it { expect(tmp { File.open subject[:user_model], &:read }).to include "has_one :role, dependent: :destroy" }
        it { expect(tmp { File.open subject[:user_model], &:read }).to include "after_save :create_role" }
        it { expect(tmp { File.open subject[:user_model], &:read }).to include "private\n\n  def create_role\n    self.role = Role.new\n  end" }
      end
    end
  end
end