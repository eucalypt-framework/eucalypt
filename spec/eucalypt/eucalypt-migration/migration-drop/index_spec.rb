require 'spec_helper'

describe Eucalypt do
  describe MigrationDrop do
    describe 'Index' do
      before(:all) { Temporary.create_app }
      after(:all) { Temporary.clear }

      describe 'No name given' do
        before(:all) do
          @migration = {file_name: 'drop_index_from_users', constant_name: 'DropIndexFromUsers'}
          tmp { execute 'migration drop index users name email nationality' }
          @migration[:file] = tmp { find_migration @migration[:file_name] }
          @migration[:contents] = tmp { File.open @migration[:file], &:read }
        end
        after(:all) { tmp { delete @migration[:file] } }

        context 'file name' do
          it { expect(@migration[:file]).to include @migration[:file_name] }
        end
        context 'constant name' do
          it { expect(@migration[:contents]).to include @migration[:constant_name] }
        end
        context 'drop (multiple columns)' do
          it { expect(@migration[:contents]).to include 'remove_index :users, column: %i[name email nationality]' }
        end
        context 'drop (single column)' do
          it do
            tmp { delete @migration[:file] }
            tmp { execute 'migration drop index users name' }
            contents = tmp { File.open find_migration(@migration[:file_name]), &:read }
            expect(contents).to include 'remove_index :users, column: :name'
          end
        end
      end
      describe 'Name given' do
        before(:all) do
          @migration = {file_name: 'drop_index_on_name_and_email_from_users', constant_name: 'DropIndexOnNameAndEmailFromUsers'}
          tmp { execute 'migration drop index users -n index_on_name_and_email' }
          @migration[:file] = tmp { find_migration @migration[:file_name] }
          @migration[:contents] = tmp { File.open @migration[:file], &:read }
        end
        after(:all) { tmp { delete @migration[:file] } }

        context 'file name' do
          it { expect(@migration[:file]).to include @migration[:file_name] }
        end
        context 'constant name' do
          it { expect(@migration[:contents]).to include @migration[:constant_name] }
        end
        context 'drop' do
          it { expect(@migration[:contents]).to include "remove_index :users, name: :index_on_name_and_email" }
        end
      end
    end
  end
end