require 'spec_helper'

describe Eucalypt do
  describe MigrationRename do
    describe 'Index' do
      before(:all) do
        @migration = {file_name: 'rename_index_on_name_on_users', constant_name: 'RenameIndexOnNameOnUsers'}
        Temporary.create_app
        tmp { execute 'migration rename index users index_on_name name_index' }
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
        it { expect(@migration[:contents]).to include 'rename_index :users, :index_on_name, :name_index' }
      end
    end
  end
end