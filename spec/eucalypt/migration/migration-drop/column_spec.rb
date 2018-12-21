require 'spec_helper'

describe Eucalypt do
  describe MigrationDrop do
    describe 'Column' do
      before(:all) do
        @migration = {file_name: 'drop_name_from_users', constant_name: 'DropNameFromUsers'}
        Temporary.create_app
        tmp { execute 'migration drop column users name' }
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
        it { expect(@migration[:contents]).to include 'remove_column :users, :name' }
      end
    end
  end
end