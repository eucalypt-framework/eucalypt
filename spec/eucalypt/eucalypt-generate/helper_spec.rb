require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Helper' do
      before(:all) { @name = 'helper_test' }
      subject { Inflect.new :helper, @name }

      describe 'files' do
        context 'helper' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate helper #{@name} --no-spec" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a helper' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it "shouldn't generate a spec" do
            expect(tmp { File.file? subject.spec_path }).to be false
          end
        end
        context 'helper + spec' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate helper #{@name}" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a helper' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it 'should generate a spec' do
            expect(tmp { File.file? subject.spec_path }).to be true
          end
        end
      end
    end
  end
end