require 'spec_helper'

describe Eucalypt do
  describe MigrationRename do
    describe 'Column' do
      before(:all) do
        @migration = {file_name: 'rename_name_on_users', constant_name: 'RenameNameOnUsers'}
        Temporary.create_app
        tmp { execute 'migration rename column users name username' }
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
        it { expect(@migration[:contents]).to include 'rename_column :users, :name, :username' }
      end
    end
  end
end