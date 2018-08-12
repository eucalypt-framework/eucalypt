require 'spec_helper'

include Eucalypt::Migration::Helpers

describe Eucalypt do
  describe Migration do
    describe Helpers do
      describe 'sanitize_table_options' do
        describe '`primary_key`' do
          context 'when option is singular' do
            it { expect(sanitize_table_options({primary_key: 'col1'})).to include [:primary_key, ':col1'] }
          end
          context 'when option is an array' do
            it { expect(sanitize_table_options({primary_key: 'col1,col2,col3'})).to include [:primary_key, '%i[col1 col2 col3]'] }
          end
        end
        describe '`id`' do
          context 'when option is boolean' do
            it do
              expect(sanitize_table_options({id: 'true'})).to include [:id, 'true']
              expect(sanitize_table_options({id: 'false'})).to include [:id, 'false']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_table_options({id: '3'})).to include [:id, ':3']
              expect(sanitize_table_options({id: 'string'})).to include [:id, ':string']
            end
          end
        end
        describe '`temporary`' do
          context 'when option is boolean' do
            it do
              expect(sanitize_table_options({temporary: 'true'})).to include [:temporary, 'true']
              expect(sanitize_table_options({temporary: 'false'})).to include [:temporary, 'false']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_table_options({temporary: '3'})).to be_empty
              expect(sanitize_table_options({temporary: 'test'})).to be_empty
            end
          end
        end
        describe '`force`' do
          context 'when option is cascase' do
            it { expect(sanitize_table_options({force: 'cascade'})).to include [:force, ':cascade'] }
          end
          context 'when option is boolean' do
            it do
              expect(sanitize_table_options({force: 'true'})).to include [:force, 'true']
              expect(sanitize_table_options({force: 'false'})).to include [:force, 'false']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_table_options({force: '3'})).to be_empty
              expect(sanitize_table_options({force: 'test'})).to be_empty
            end
          end
        end
        context 'other options' do
          it { expect(sanitize_table_options({test: 'test'})).to be_empty }
        end
      end
      describe 'sanitize_index_options' do
        describe '`unique`' do
          context 'when option is boolean' do
            it do
              expect(sanitize_index_options({unique: 'true'})).to include [:unique, 'true']
              expect(sanitize_index_options({unique: 'false'})).to include [:unique, 'false']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_index_options({unique: '3'})).to be_empty
              expect(sanitize_index_options({unique: 'test'})).to be_empty
            end
          end
        end
        describe '`length`' do
          context 'when option is numeric' do
            it do
              expect(sanitize_index_options({length: '3'})).to include [:length, '3']
              expect(sanitize_index_options({length: '15'})).to include [:length, '15']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_index_options({length: 'true'})).to be_empty
              expect(sanitize_index_options({length: 'test'})).to be_empty
            end
          end
        end
        describe '`where`' do
          context 'when option is a valid string' do
            it { expect(sanitize_index_options({where: 'test'})).to include [:where, ':test'] }
          end
          context 'when option is an invalid string' do
            it { expect(sanitize_index_options({where: '?!?@'})).to be_empty }
          end
        end
        describe '`using`' do
          context 'when option is a valid string' do
            it { expect(sanitize_index_options({using: 'test'})).to include [:using, ':test'] }
          end
          context 'when option is an invalid string' do
            it { expect(sanitize_index_options({using: '?!?@'})).to be_empty }
          end
        end
        describe '`type`' do
          context 'when option is a valid string' do
            it { expect(sanitize_index_options({type: 'test'})).to include [:type, ':test'] }
          end
          context 'when option is an invalid string' do
            it { expect(sanitize_index_options({type: '?!?@'})).to be_empty }
          end
        end
        context 'other options' do
          it { expect(sanitize_index_options({test: 'test'})).to be_empty }
        end
      end
      describe 'sanitize_column_options' do
        describe '`limit`' do
          context 'when option is numeric' do
            it do
              expect(sanitize_column_options({limit: '3'})).to include [:limit, '3']
              expect(sanitize_column_options({limit: '15'})).to include [:limit, '15']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_column_options({limit: 'true'})).to be_empty
              expect(sanitize_column_options({limit: 'test'})).to be_empty
            end
          end
        end
        describe '`default`' do
          context 'when option is nil or null' do
            it do
              expect(sanitize_column_options({default: 'nil'})).to include [:default, 'nil']
              expect(sanitize_column_options({default: 'null'})).to include [:default, 'nil']
            end
          end
          context 'when option is numeric' do
            it do
              expect(sanitize_column_options({default: '3'})).to include [:default, '3']
              expect(sanitize_column_options({default: '15'})).to include [:default, '15']
            end
          end
          context 'when option is some other type' do
            it { expect(sanitize_column_options({default: 'test'})).to include [:default, "\'test\'"] }
          end
        end
        describe '`null`' do
          context 'when option is boolean' do
            it do
              expect(sanitize_column_options({null: 'true'})).to include [:null, 'true']
              expect(sanitize_column_options({null: 'false'})).to include [:null, 'false']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_column_options({null: '3'})).to be_empty
              expect(sanitize_column_options({null: 'test'})).to be_empty
            end
          end
        end
        describe '`precision`' do
          context 'when option is numeric' do
            it do
              expect(sanitize_column_options({precision: '3'})).to include [:precision, '3']
              expect(sanitize_column_options({precision: '15'})).to include [:precision, '15']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_column_options({precision: 'true'})).to be_empty
              expect(sanitize_column_options({precision: 'test'})).to be_empty
            end
          end
        end
        describe '`scale`' do
          context 'when option is numeric' do
            it do
              expect(sanitize_column_options({scale: '3'})).to include [:scale, '3']
              expect(sanitize_column_options({scale: '15'})).to include [:scale, '15']
            end
          end
          context 'when option is some other type' do
            it do
              expect(sanitize_column_options({scale: 'true'})).to be_empty
              expect(sanitize_column_options({scale: 'test'})).to be_empty
            end
          end
        end
        context 'other options' do
          it { expect(sanitize_column_options({test: 'test'})).to be_empty }
        end
      end
    end
  end
end