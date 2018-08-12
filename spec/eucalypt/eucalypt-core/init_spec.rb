require 'spec_helper'

describe Eucalypt::CLI do
  describe 'Init' do
    after(:all) { Temporary.clear }

    describe 'without options' do
      context 'with a unique directory name' do
        before(:all) { Temporary.create_app }
        after(:all) { Temporary.clear }

        it 'should initialize the application' do
          expect(tmp { Eucalypt.app? '.' }).to be true
        end

        context 'core application file' do
          it 'should exist' do
            expect(tmp { File.file? Eucalypt::APP_FILE }).to be true
          end

          it do
            expect(tmp { File.open Eucalypt::APP_FILE, &:read }).to include Eucalypt::VERSION
          end
        end
      end
      context 'with the name of an already existing directory' do
        before { Temporary.create_app }
        after { Temporary.clear }

        it "shouldn't initialize the application" do
          output = Temporary.create_app
          expect(output).to include "Directory tmp already exists."
        end
      end
    end
    describe 'with options' do
      subject do
        {
          controller: File.join('app', 'controllers', 'blog_controller.rb'),
          controller_spec: File.join('spec', 'controllers', 'blog_controller_spec.rb'),
          helper: File.join('app', 'helpers', 'blog_helper.rb'),
          helper_spec: File.join('spec', 'helpers', 'blog_helper_spec.rb')
        }
      end

      context '--blog, -b' do
        before(:all) { Temporary.create_app '-b' }
        after(:all) { Temporary.clear }

        it 'should set up a blog environment' do
          expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
        end

        it 'should create a blog controller' do
          expect(tmp { File.file? subject[:controller] }).to be true
        end

        it 'should create a blog controller spec' do
          expect(tmp { File.file? subject[:controller_spec] }).to be true
        end

        it 'should correctly route the controller' do
          expect(tmp { File.open subject[:controller], &:read }).to include "route: '/blog'"
        end

        it 'should create a blog helper' do
          expect(tmp { File.file? subject[:helper] }).to be true
        end

        it 'should create a blog helper spec' do
          expect(tmp { File.file? subject[:helper_spec] }).to be true
        end
      end
      context '--blog --route, -br' do
        context 'with a specified route' do
          before(:all) { Temporary.create_app '-br', 'posts' }
          after(:all) { Temporary.clear }

          it 'should set up a blog environment' do
            expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
          end

          it 'should correctly route the controller' do
            expect(tmp { File.open subject[:controller], &:read }).to include "route: '/posts'"
          end
        end
        context 'without a specified route' do
          before(:all) { Temporary.create_app '-br' }
          after(:all) { Temporary.clear }

          it 'should set up a blog environment' do
            expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
          end

          it 'should correctly route the controller' do
            expect(tmp { File.open subject[:controller], &:read }).to include "route: '/blog'"
          end
        end
      end
      context '--warden, -w' do
        before { Temporary.create_app '-w' }
        after { Temporary.clear }

        it 'should set up Warden' do
          expect(tmp { Helpers::Gemfile.include? %w[warden], '.' }).to be true
        end
      end
      context '--pundit, -p' do
        before { Temporary.create_app '-p' }
        after { Temporary.clear }

        it "shouldn't set up Pundit" do
          expect(tmp { Helpers::Gemfile.include? %w[pundit], '.' }).to be false
        end
      end
      context '--warden --pundit, -wp' do
        before { Temporary.create_app '-wp' }
        after { Temporary.clear }

        it 'should set up Warden and Pundit' do
          expect(tmp { Helpers::Gemfile.include? %w[warden pundit], '.' }).to be true
        end
      end
      context '--git' do
        after { Temporary.clear }

        it 'should run `git init`' do
          silence { Eucalypt::CLI.start %w[init tmp -s --no-bundle --git] }
          expect(tmp { File.directory? '.git' }).to be true
        end
      end
      context '--no-git' do
        after { Temporary.clear }

        it "shouldn't run `git init` " do
          silence { Eucalypt::CLI.start %w[init tmp -s --no-bundle --no-git] }
          expect(tmp { File.directory? '.git' }).to be false
        end
      end
      context '--bundle' do
        after { Temporary.clear }

        it 'should run `bundle install`' do
          output = silence { Eucalypt::CLI.start %w[init tmp -s --bundle --no-git] }
          expect(output).to include 'bundle install'
        end
      end
      context '--no-bundle' do
        after { Temporary.clear }

        it "shouldn't run `bundle install`" do
          output = silence { Eucalypt::CLI.start %w[init tmp -s --no-bundle --no-git] }
          expect(output).not_to include 'bundle install'
        end
      end
    end
  end
end