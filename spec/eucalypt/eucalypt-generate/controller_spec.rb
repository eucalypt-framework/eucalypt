require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Controller' do
      before(:all) { @name = 'controller_test' }
      subject { Inflect.new :controller, @name }

      describe 'files' do
        context 'controller' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate controller #{@name} --no-spec" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a controller' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it "shouldn't generate a spec" do
            expect(tmp { File.file? subject.spec_path }).to be false
          end
        end
        context 'controller + spec' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate controller #{@name}" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a controller' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it 'should generate a spec' do
            expect(tmp { File.file? subject.spec_path }).to be true
          end
        end
      end
      context '--rest, -r' do
        before(:all) do
          Temporary.create_app
          tmp { execute "generate controller #{@name} -r" }
        end
        after(:all) { Temporary.clear }

        it 'should generate a controller' do
          expect(tmp { File.file? subject.file_path }).to be true
        end

        it 'should pluralize the controller route' do
          route = Inflect.route(subject.resources)
          expect(tmp { File.open subject.file_path, &:read }).to include "route: '/#{route}'"
        end

        it 'should contain all of the BREAD methods' do
          methods = ['GET - Browse', 'GET - Read', 'POST - Edit', 'POST - Add', 'POST - Delete']
          expect(tmp { File.open subject.file_path, &:read }).to include *methods
        end
      end
    end
  end
end