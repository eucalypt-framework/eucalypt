require 'spec_helper'

describe Eucalypt do
  describe Eucalypt::Migration do
    describe 'Blank' do
      before(:all) do
        @migration = {file_name: 'test_migration', constant_name: 'TestMigration'}
        Temporary.create_app
        tmp { execute 'migration blank test_migration' }
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
        it { expect(@migration[:contents]).to include "def change\n  end" }
      end
    end
  end
end