require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Model' do
      before(:all) { @name = 'model_test' }
      subject { Inflect.new :model, @name }

      describe 'files' do
        context 'model' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate model #{@name} --no-spec" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a model' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it "shouldn't generate a spec" do
            expect(tmp { File.file? subject.spec_path }).to be false
          end
        end
        context 'model + spec' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate model #{@name}" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a model' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it 'should generate a spec' do
            expect(tmp { File.file? subject.spec_path }).to be true
          end
        end
      end
      describe '--table' do
        context 'without columns' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate model #{@name} --table --no-spec" }
            @migration = tmp { find_migration "create_#{Inflect.resources @name}" }
            @contents = tmp { File.open @migration, &:read }
          end
          after(:all) { Temporary.clear }

          it 'should generate a migration' do
            expect(tmp { File.file? @migration }).to be true
          end

          it 'should create a table' do
            expect(@contents).to include 'create_table'
          end

          it "should not have any columns" do
            expect(@contents.lines.count).to be 5
          end
        end
        context 'with columns' do
          before(:all) do
            Temporary.create_app
            declarations = %w[col1:string col2:integer col3:decimal]
            @columns = {}
            declarations.each do |d|
              column, type = d.split ?:
              @columns[column.to_sym] = type
            end
            tmp { execute "generate model #{@name} #{declarations*' '} --table --no-spec" }
            @migration = tmp { find_migration "create_#{Inflect.resources @name}" }
            @contents = tmp { File.open @migration, &:read }
          end
          after(:all) { Temporary.clear }

          it 'should generate a migration' do
            expect(tmp { File.file? @migration }).to be true
          end

          it 'should create a table' do
            expect(@contents).to include 'create_table'
          end

          it "should have the correct column names and types" do
            expect(@contents).to include *@columns.map {|c,t| "t.#{t} #{c.inspect}"}
          end
        end
      end
      context '--no-table' do
        before(:all) do
          Temporary.create_app
          tmp { execute "generate model #{@name} --no-table --no-spec" }
        end
        after(:all) { Temporary.clear }

        it "shouldn't generate a migration" do
          expect(tmp { Dir[File.join 'db', 'migrate', '*.rb'] }).to be_empty
        end
      end
    end
  end
end