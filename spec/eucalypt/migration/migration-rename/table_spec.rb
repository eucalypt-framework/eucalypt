require 'spec_helper'

describe Eucalypt do
  describe MigrationRename do
    describe 'Table' do
      before(:all) do
        @migration = {file_name: 'rename_users_to_accounts', constant_name: 'RenameUsersToAccounts'}
        Temporary.create_app
        tmp { execute 'migration rename table users accounts' }
        @migration[:file] = tmp { find_migration @migration[:file_name] }
        @migration[:contents] = tmp { File.open @migration[:file], &:read }
      end
      after(:all) { Temporary.clear }

      context 'file name' do
        it { expect(@migration[:file]).to include @migration[:file_name] }
      end
      context 'constant name' do
        it { expect(@migration[:contents]).to include @migration[:constant_name] }
      end
      context 'drop' do
        it { expect(@migration[:contents]).to include 'rename_table :users, :accounts' }
      end
    end
  end
end