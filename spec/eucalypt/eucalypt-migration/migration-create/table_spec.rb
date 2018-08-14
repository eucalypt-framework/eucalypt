require 'spec_helper'

describe Eucalypt do
  describe MigrationCreate do
    describe 'Table' do
      before(:all) do
        @migration = {name: 'users', file_name: 'create_users', constant_name: 'CreateUsers'}
        Temporary.create_app
      end
      after(:all) { Temporary.clear }

      describe 'No options' do
        describe 'with no columns' do
          before(:all) do
            tmp { execute 'migration create table users' }
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
          context 'table' do
            it { expect(@migration[:contents]).to include 'create_table :users' }
          end
        end
        describe 'with one column' do
          before(:all) do
            tmp { execute 'migration create table users name:string' }
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
          context 'table' do
            it { expect(@migration[:contents]).to include 'create_table :users do |t|', 't.string :name' }
          end
        end
        describe 'with many columns' do
          before(:all) do
            tmp { execute 'migration create table users name:string email:string member:boolean' }
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
          context 'table' do
            it { expect(@migration[:contents]).to include 'create_table :users do |t|', 't.string :name', 't.string :email', 't.boolean :member' }
          end
        end
      end
      describe 'Options' do
        after { tmp { Dir.glob(File.join 'db', 'migrate', "*#{@migration[:file_name]}.rb") {|f| FileUtils.rm f } } }

        context 'primary_key array' do
          before do
            options = %w[primary_key:user_id,sponsor_id]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: %i[user_id sponsor_id]' }
        end

        context 'primary_key id temporary force' do
          before do
            options = %w[primary_key:user_id id:false temporary:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, id: false, temporary: false, force: :cascade' }
        end
        context 'primary_key id temporary' do
          before do
            options = %w[primary_key:user_id id:false temporary:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, id: false, temporary: false' }
        end
        context 'primary_key id force' do
          before do
            options = %w[primary_key:user_id id:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, id: false, force: :cascade' }
        end
        context 'primary_key id' do
          before do
            options = %w[primary_key:user_id id:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, id: false' }
        end
        context 'primary_key temporary force' do
          before do
            options = %w[primary_key:user_id temporary:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, temporary: false, force: :cascade' }
        end
        context 'primary_key temporary' do
          before do
            options = %w[primary_key:user_id temporary:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, temporary: false' }
        end
        context 'primary_key force' do
          before do
            options = %w[primary_key:user_id force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id, force: :cascade' }
        end
        context 'primary_key' do
          before do
            options = %w[primary_key:user_id]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, primary_key: :user_id' }
        end
        context 'id temporary force' do
          before do
            options = %w[id:false temporary:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, id: false, temporary: false, force: :cascade' }
        end
        context 'id temporary' do
          before do
            options = %w[id:false temporary:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, id: false, temporary: false' }
        end
        context 'id force' do
          before do
            options = %w[id:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, id: false, force: :cascade' }
        end
        context 'id' do
          before do
            options = %w[id:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, id: false' }
        end
        context 'temporary force' do
          before do
            options = %w[temporary:false force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, temporary: false, force: :cascade' }
        end
        context 'temporary' do
          before do
            options = %w[temporary:false]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, temporary: false' }
        end
        context 'force' do
          before do
            options = %w[force:cascade]
            tmp { execute "migration create table users -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'create_table :users, force: :cascade' }
        end
      end
    end
  end
end