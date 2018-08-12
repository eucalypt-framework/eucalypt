require 'spec_helper'

describe Eucalypt do
  describe 'Init' do
    after { Temporary.clear }

    describe 'without options' do
      context 'with a unique directory name' do
        before { Temporary.create_app }

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
        it "shouldn't initialize the application" do
          Temporary.create_app
          output = Temporary.create_app
          expect(output).to include "Directory tmp already exists."
        end
      end
    end
    describe 'with options' do
      context '--blog, -b' do
        it 'should set up a blog environment' do
          Temporary.create_app '-b'
          expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
        end
      end
      context '--blog --route, -br' do
        context 'with a specified route' do
          it 'should set up a blog environment' do
            Temporary.create_app '-br', 'posts'
            expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
          end

          it 'should correctly route the controller' do
            Temporary.create_app '-br', 'posts'
            controller = File.join 'app', 'controllers', 'blog_controller.rb'
            expect(tmp { File.open controller, &:read }).to include "route: '/posts'"
          end
        end
        context 'without a specified route' do
          it 'should set up a blog environment' do
            Temporary.create_app '-br'
            expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
          end

          it 'should correctly route the controller' do
            Temporary.create_app '-br'
            controller = File.join 'app', 'controllers', 'blog_controller.rb'
            expect(tmp { File.open controller, &:read }).to include "route: '/blog'"
          end
        end
      end
      context '--warden, -w' do
        it 'should set up Warden' do
          Temporary.create_app '-w'
          expect(tmp { Helpers::Gemfile.include? %w[warden], '.' }).to be true
        end
      end
      context '--pundit, -p' do
        it "shouldn't set up Pundit" do
          Temporary.create_app '-p'
          expect(tmp { Helpers::Gemfile.include? %w[pundit], '.' }).to be false
        end
      end
      context '--warden --pundit, -wp' do
        it 'should set up Warden and Pundit' do
          Temporary.create_app '-wp'
          expect(tmp { Helpers::Gemfile.include? %w[warden pundit], '.' }).to be true
        end
      end
      context '--git' do
        let(:args) { %w[init tmp -s --no-bundle --git] }

        it 'should run `git init`' do
          silence { Eucalypt::CLI.start args }
          expect(tmp { File.directory? '.git' }).to be true
        end
      end
      context '--no-git' do
        let(:args) { %w[init tmp -s --no-bundle --no-git] }

        it "shouldn't run `git init` " do
          silence { Eucalypt::CLI.start args }
          expect(tmp { File.directory? '.git' }).to be false
        end
      end
      context '--bundle' do
        let(:args) { %w[init tmp -s --bundle --no-git] }

        it 'should run `bundle install`' do
          output = silence { Eucalypt::CLI.start args }
          expect(output).to include 'bundle install'
        end
      end
      context '--no-bundle' do
        let(:args) { %w[init tmp -s --no-bundle --no-git] }

        it "shouldn't run `bundle install`" do
          output = silence { Eucalypt::CLI.start args }
          expect(output).not_to include 'bundle install'
        end
      end
    end
  end
end