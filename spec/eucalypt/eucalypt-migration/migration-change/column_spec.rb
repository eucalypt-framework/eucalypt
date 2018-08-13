require 'spec_helper'

describe Eucalypt do
  describe MigrationChange do
    describe 'Column' do
      before(:all) do
        @migration = {name: 'name', file_name: 'change_name_column_on_users', constant_name: 'ChangeNameColumnOnUsers'}
        Temporary.create_app
      end
      after(:all) { Temporary.clear }

      describe 'No options' do
        before(:all) do
          tmp { execute 'migration change column users name string' }
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
        context 'column' do
          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string' }
        end
      end
      describe 'Options' do
        after { tmp { Dir.glob(File.join 'db', 'migrate', "*#{@migration[:file_name]}.rb") {|f| FileUtils.rm f } } }

        context 'limit default null precision scale' do
          before do
            options = %w[limit:2 default:null null:false precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, null: false, precision: 3, scale: 5' }
        end
        context 'limit default null precision' do
          before do
            options = %w[limit:2 default:null null:false precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, null: false, precision: 3' }
        end
        context 'limit default null scale' do
          before do
            options = %w[limit:2 default:null null:false scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, null: false, scale: 5' }
        end
        context 'limit default null' do
          before do
            options = %w[limit:2 default:null null:false]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, null: false' }
        end
        context 'limit default precision scale' do
          before do
            options = %w[limit:2 default:null precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, precision: 3, scale: 5' }
        end
        context 'limit default precision' do
          before do
            options = %w[limit:2 default:null precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, precision: 3' }
        end
        context 'limit default scale' do
          before do
            options = %w[limit:2 default:null scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil, scale: 5' }
        end
        context 'limit default' do
          before do
            options = %w[limit:2 default:null]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, default: nil' }
        end
        context 'limit null precision scale' do
          before do
            options = %w[limit:2 null:false precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, null: false, precision: 3, scale: 5' }
        end
        context 'limit null precision' do
          before do
            options = %w[limit:2 null:false precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, null: false, precision: 3' }
        end
        context 'limit null scale' do
          before do
            options = %w[limit:2 null:false scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, null: false, scale: 5' }
        end
        context 'limit null' do
          before do
            options = %w[limit:2 null:false]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, null: false' }
        end
        context 'limit precision scale' do
          before do
            options = %w[limit:2 precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, precision: 3, scale: 5' }
        end
        context 'limit precision' do
          before do
            options = %w[limit:2 precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, precision: 3' }
        end
        context 'limit scale' do
          before do
            options = %w[limit:2 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2, scale: 5' }
        end
        context 'limit' do
          before do
            options = %w[limit:2]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, limit: 2' }
        end
        context 'default null precision scale' do
          before do
            options = %w[default:null null:false precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, null: false, precision: 3, scale: 5' }
        end
        context 'default null precision' do
          before do
            options = %w[default:null null:false precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, null: false, precision: 3' }
        end
        context 'default null scale' do
          before do
            options = %w[default:null null:false scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, null: false, scale: 5' }
        end
        context 'default null' do
          before do
            options = %w[default:null null:false]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, null: false' }
        end
        context 'default precision scale' do
          before do
            options = %w[default:null precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, precision: 3, scale: 5' }
        end
        context 'default precision' do
          before do
            options = %w[default:null precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, precision: 3' }
        end
        context 'default scale' do
          before do
            options = %w[default:null scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil, scale: 5' }
        end
        context 'default' do
          before do
            options = %w[default:null]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, default: nil' }
        end
        context 'null precision scale' do
          before do
            options = %w[null:false precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, null: false, precision: 3, scale: 5' }
        end
        context 'null precision' do
          before do
            options = %w[null:false precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, null: false, precision: 3' }
        end
        context 'null scale' do
          before do
            options = %w[null:false scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, null: false, scale: 5' }
        end
        context 'null' do
          before do
            options = %w[null:false]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, null: false' }
        end
        context 'precision scale' do
          before do
            options = %w[precision:3 scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, precision: 3, scale: 5' }
        end
        context 'precision' do
          before do
            options = %w[precision:3]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, precision: 3' }
        end
        context 'scale' do
          before do
            options = %w[scale:5]
            tmp { execute "migration change column users name string -o #{options*' '}" }
            @migration[:file] = tmp { find_migration @migration[:file_name] }
            @migration[:contents] = tmp { File.open @migration[:file], &:read }
          end

          it { expect(@migration[:contents]).to include 'change_column :users, :name, :string, scale: 5' }
        end
      end
    end
  end
end