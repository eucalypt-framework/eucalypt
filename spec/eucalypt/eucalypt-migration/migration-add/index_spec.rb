require 'spec_helper'

describe Eucalypt do
  describe MigrationAdd do
    describe 'Index' do
      before(:all) do
        @migration = {name: 'name', file_name: 'add_index_to_users', constant_name: 'AddIndexToUsers'}
        Temporary.create_app
      end
      after(:all) { Temporary.clear }

      describe 'No options' do
        describe 'with one column' do
          before(:all) do
            tmp { execute 'migration add index users name' }
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
          context 'index' do
            it { expect(@migration[:contents]).to include 'add_index :users, :name' }
          end
        end
        describe 'with many columns' do
          before(:all) do
            tmp { execute 'migration add index users name email nationality' }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end
          after(:all) { tmp { delete @migration[:file] } }

          context 'index' do
            it { expect(@migration[:contents]).to include 'add_index :users, %i[name email nationality]' }
          end
        end
      end
      describe 'Options' do
        describe '--name, -n' do
          before(:all) do
            @m = {name: 'name', file_name: 'add_index_on_name_to_users', constant_name: 'AddIndexOnNameToUsers'}
            tmp { execute 'migration add index users name -n index_on_name' }
            @m[:file] = tmp { find_migration @m[:file_name] }
            @m[:contents] = tmp { File.open @m[:file], &:read }
          end
          after(:all) { tmp { delete @m[:file] } }

          it 'should have the correct file name' do
            expect(@m[:file]).to include @m[:file_name]
          end
          it 'should have the correct constant name' do
            expect(@m[:contents]).to include @m[:constant_name]
          end
          it 'should name the index' do
            expect(@m[:contents]).to include 'add_index :users, :name, name: :index_on_name'
          end
        end
        describe '--options, -o' do
          after { tmp { Dir.glob(File.join 'db', 'migrate', "*#{@migration[:file_name]}.rb") {|f| FileUtils.rm f } } }

          context 'unique length where using type' do
            before do
              options = %w[unique:true length:4 where:test using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, where: :test, using: :btree, type: :test' }
          end
          context 'unique length where using' do
            before do
              options = %w[unique:true length:4 where:test using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, where: :test, using: :btree' }
          end
          context 'unique length where type' do
            before do
              options = %w[unique:true length:4 where:test type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, where: :test, type: :test' }
          end
          context 'unique length where' do
            before do
              options = %w[unique:true length:4 where:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, where: :test' }
          end
          context 'unique length using type' do
            before do
              options = %w[unique:true length:4 using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, using: :btree, type: :test' }
          end
          context 'unique length using' do
            before do
              options = %w[unique:true length:4 using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, using: :btree' }
          end
          context 'unique length type' do
            before do
              options = %w[unique:true length:4 type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4, type: :test' }
          end
          context 'unique length' do
            before do
              options = %w[unique:true length:4]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, length: 4' }
          end
          context 'unique where using type' do
            before do
              options = %w[unique:true where:test using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, where: :test, using: :btree, type: :test' }
          end
          context 'unique where using' do
            before do
              options = %w[unique:true where:test using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, where: :test, using: :btree' }
          end
          context 'unique where type' do
            before do
              options = %w[unique:true where:test type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, where: :test, type: :test' }
          end
          context 'unique where' do
            before do
              options = %w[unique:true where:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, where: :test' }
          end
          context 'unique using type' do
            before do
              options = %w[unique:true using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, using: :btree, type: :test' }
          end
          context 'unique using' do
            before do
              options = %w[unique:true using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, using: :btree' }
          end
          context 'unique type' do
            before do
              options = %w[unique:true type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true, type: :test' }
          end
          context 'unique' do
            before do
              options = %w[unique:true]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, unique: true' }
          end
          context 'length where using type' do
            before do
              options = %w[length:4 where:test using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, where: :test, using: :btree, type: :test' }
          end
          context 'length where using' do
            before do
              options = %w[length:4 where:test using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, where: :test, using: :btree' }
          end
          context 'length where type' do
            before do
              options = %w[length:4 where:test type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, where: :test, type: :test' }
          end
          context 'length where' do
            before do
              options = %w[length:4 where:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, where: :test' }
          end
          context 'length using type' do
            before do
              options = %w[length:4 using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, using: :btree, type: :test' }
          end
          context 'length using' do
            before do
              options = %w[length:4 using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, using: :btree' }
          end
          context 'length type' do
            before do
              options = %w[length:4 type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4, type: :test' }
          end
          context 'length' do
            before do
              options = %w[length:4]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, length: 4' }
          end
          context 'where using type' do
            before do
              options = %w[where:test using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, where: :test, using: :btree, type: :test' }
          end
          context 'where using' do
            before do
              options = %w[where:test using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, where: :test, using: :btree' }
          end
          context 'where type' do
            before do
              options = %w[where:test type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, where: :test, type: :test' }
          end
          context 'where' do
            before do
              options = %w[where:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, where: :test' }
          end
          context 'using type' do
            before do
              options = %w[using:btree type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, using: :btree, type: :test' }
          end
          context 'using' do
            before do
              options = %w[using:btree]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, using: :btree' }
          end
          context 'type' do
            before do
              options = %w[type:test]
              tmp { execute "migration add index users name -o #{options*' '}" }
              @migration[:file] = tmp { find_migration @migration[:file_name] }
              @migration[:contents] = tmp { File.open @migration[:file], &:read }
            end

            it { expect(@migration[:contents]).to include 'add_index :users, :name, type: :test' }
          end
        end
      end
    end
  end
end