require 'spec_helper'

describe Eucalypt do
  describe MigrationDrop do
    describe 'Table' do
      before(:all) do
        @migration = {file_name: 'drop_users', constant_name: 'DropUsers'}
        Temporary.create_app
        tmp { execute 'migration drop table users' }
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
        it { expect(@migration[:contents]).to include 'drop_table :users' }
      end
    end
  end
end