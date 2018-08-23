require 'spec_helper'

describe Eucalypt do
  describe SecurityPolicy do
    describe 'Generate' do
      before :all do
        Temporary.create_app
        tmp do
          execute_many do |t|
            t << 'security warden setup --no-controller'
            t << 'security pundit setup'
            t << 'security policy generate test'
            t << 'security policy generate test-headless --headless'
          end
        end
      end
      after(:all) { Temporary.clear }

      subject do
        {
          headless: {
            policy: File.join('app', 'policies', 'test_headless_policy.rb'),
            role_model: File.join('app', 'models', 'test_headless_role.rb'),
            role_migration: tmp { find_migration('create_test_headless_roles') },
            add_column_migration: tmp { find_migration('add_test_headless_to_roles') }
          },
          non_headless: {
            policy: File.join('app', 'policies', 'test_policy.rb'),
            role_model: File.join('app', 'models', 'test_role.rb'),
            role_migration: tmp { find_migration('create_test_roles') },
            add_column_migration: tmp { find_migration('add_test_to_roles') }
          }
        }
      end

      context 'non-headless' do
        it 'should create a policy file' do
          expect(tmp { File.file? subject[:non_headless][:policy] }).to be true
        end

        it 'should create a role model file' do
          expect(tmp { File.file? subject[:non_headless][:role_model] }).to be true
        end

        it 'should create a roles table creation migration' do
          expect(subject[:non_headless][:role_migration]).not_to be nil
          expect(tmp { File.file? subject[:non_headless][:role_migration] }).to be true
        end

        it 'should add validation to the role model' do
          contents = tmp { File.open subject[:non_headless][:role_model], &:read }
          expect(contents).to include "validates :permission, uniqueness: true"
        end

        it 'should add a new column to the roles table' do
          expect(subject[:non_headless][:add_column_migration]).not_to be nil
          expect(tmp { File.file? subject[:non_headless][:add_column_migration] }).to be true
        end

        it 'should not be headless' do
          contents = tmp { File.open subject[:non_headless][:policy], &:read }
          expect(contents).not_to include 'Struct.new'
        end
      end

      context 'headless' do
        it do
          contents = tmp { File.open subject[:headless][:policy], &:read }
          expect(contents).to include 'Struct.new'
        end
      end
    end
  end
end