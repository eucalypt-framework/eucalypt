require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Scaffold' do

      describe 'no options' do
        context 'with no columns' do
          it 'should generate a controller' do

          end

          it 'should generate a controller spec' do

          end

          it 'should generate a model' do

          end

          it 'should generate a model spec' do

          end

          it 'should generate a migration' do

          end

          it 'should generate a table' do

          end

          it 'should not have any columns' do

          end

          it 'should generate a helper' do

          end

          it 'should generate a helper spec' do

          end
        end

        context 'with columns' do
          it 'should generate a controller' do

          end

          it 'should generate a controller spec' do

          end

          it 'should generate a model' do

          end

          it 'should generate a model spec' do

          end

          it 'should generate a migration' do

          end

          it 'should generate a table' do

          end

          it 'should have the correct column names and types' do

          end

          it 'should generate a helper' do

          end

          it 'should generate a helper spec' do

          end
        end
      end
      describe 'options' do
        describe '--no, -n' do
          # The massive part
        end
        context '--rest, -r' do
          it 'should generate a REST-style controller' do

          end
        end
        context '--policy, -p' do
          # Set up warden and pundit
          it 'should generate a policy file' do

          end

          it "should generate a REST-style controller without authorization" do

          end
        end
        context '--rest --policy, -rp' do
          # Set up warden and pundit
          it 'should generate an REST-style controller with authorization' do

          end
        end
        context '--no-table' do
          it "shouldn't create a table migration" do

          end
        end
      end
    end
  end
end