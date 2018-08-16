require 'spec_helper'

describe Eucalypt do
  describe SecurityPolicy do
    before :all do
      Temporary.create_app
      tmp do
        execute_many do |t|
          t << 'security warden setup --no-controller'
          t << 'security pundit setup'
          t << 'security policy generate test'
        end
      end
    end
    after(:all) { Temporary.clear }

    context 'Generate' do
      subject do
        {
          user_model: File.join('app', 'models', 'user.rb'),
          policy: File.join('app', 'policies', 'test_policy.rb'),
          role_model: File.join('app', 'models', 'test_role.rb'),
          role_migration: tmp { find_migration('create_test_roles') },
          add_column_migration: tmp { find_migration('add_test_to_roles') }
        }
      end

      it 'should create a policy file' do
        expect(tmp { File.file? subject[:policy] }).to be true
      end

      it 'should create a role model file' do
        expect(tmp { File.file? subject[:role_model] }).to be true
      end

      it 'should create a roles table creation migration' do
        expect(subject[:role_migration]).not_to be nil
        expect(tmp { File.file? subject[:role_migration] }).to be true
      end

      it 'should add validation to the role model' do
        contents = tmp { File.open subject[:role_model], &:read }
        expect(contents).to include "validates :permission, uniqueness: true"
      end

      it 'should add a new column to the roles table' do
        expect(subject[:add_column_migration]).not_to be nil
        expect(tmp { File.file? subject[:add_column_migration] }).to be true
      end
    end
  end
end