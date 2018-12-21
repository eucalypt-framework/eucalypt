require 'spec_helper'

describe Eucalypt do
  describe Blog do
    describe 'Setup' do
      subject do
        {
          controller: File.join('app', 'controllers', 'blog_controller.rb'),
          controller_spec: File.join('spec', 'controllers', 'blog_controller_spec.rb'),
          helper: File.join('app', 'helpers', 'blog_helper.rb'),
          helper_spec: File.join('spec', 'helpers', 'blog_helper_spec.rb'),
          articles_layout: File.join('app', 'views','layouts', 'blog', 'articles.erb'),
          article_layout: File.join('app', 'views','layouts', 'blog', 'article.erb'),
          articles_view: File.join('app','views', 'blog', 'articles.erb'),
          article_view: File.join('app', 'views', 'blog', 'article.erb'),
          article_search: File.join('app', 'views', 'blog', 'search.erb')
        }
      end

      context 'no flags' do
        before :all do
          Temporary.create_app
          tmp { execute 'blog setup' }
        end
        after(:all) { Temporary.clear }

        it 'should set up a blog environment' do
          expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
        end

        it 'should create a blog controller' do
          expect(tmp { File.file? subject[:controller] }).to be true
        end

        it 'should create a blog controller spec' do
          expect(tmp { File.file? subject[:controller_spec]}).to be true
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

        it "should create a layout for displaying all articles " do
          expect(tmp { File.file? subject[:articles_layout] }).to be true
        end

        it "should create a layout for displaying one article" do
          expect(tmp { File.file? subject[:article_layout] }).to be true
        end

        it "should create a view for displaying all articles" do
          expect(tmp { File.file? subject[:articles_view] }).to be true
        end

        it "should create a view for displaying one article" do
          expect(tmp { File.file? subject[:article_view] }).to be true
        end

        it "should create a view for searching articles " do
          expect(tmp { File.file? subject[:article_search] }).to be true
        end
      end
      context '--route, -r' do
        before :all do
          Temporary.create_app
          @route = 'test'
          tmp { execute "blog setup -r #{@route}" }
        end
        after(:all) { Temporary.clear }

        it 'should set up a blog environment' do
          expect(tmp { Helpers::Gemfile.include? %w[front_matter_parser rdiscount], '.' }).to be true
        end

        it 'should correctly route the controller' do
          expect(tmp { File.open subject[:controller], &:read }).to include "route: '/test'"
        end
      end
    end
  end
end