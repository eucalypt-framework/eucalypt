require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Controller' do
      let(:name) { 'controller_test' }
      subject { Inflect.new :controller, name }
      before { Temporary.create_app }
      after { Temporary.clear }

      describe 'files' do
        context 'controller' do
          before { tmp { execute "generate controller #{name} --no-spec" } }

          it 'should generate a controller' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it "shouldn't generate a spec" do
            expect(tmp { File.file? subject.spec_path }).to be false
          end
        end
        context 'controller + spec' do
          before { tmp { execute "generate controller #{name}" } }

          it 'should generate a controller' do
            expect(tmp { File.file? subject.file_path }).to be true
          end

          it 'should generate a spec' do
            expect(tmp { File.file? subject.spec_path }).to be true
          end
        end
      end
      context '--rest, -r' do
        before { tmp { execute "generate controller #{name} -r" } }

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