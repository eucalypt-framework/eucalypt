require 'spec_helper'

describe Eucalypt do
  describe SecurityPolicyPermission do
    before :all do
      Temporary.create_app
      tmp do
        execute_many do |t|
          t << 'security warden setup --no-controller'
          t << 'security pundit setup'
          t << 'security policy generate test'
          t << 'security policy permission generate test create'
        end
      end
    end
    after(:all) { Temporary.clear }

    context 'Generate' do
      subject do
        {migration: tmp { find_migration('add_create_permission_to_test_policy') }}
      end

      it 'should add a new permission to the policy roles table' do
        expect(subject[:migration]).not_to be nil
        expect(tmp { File.file? subject[:migration] }).to be true
      end
    end
  end
end