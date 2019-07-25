require 'spec_helper'

describe Helpers::Inflect do
  subject { Helpers::Inflect }
  let :examples do
    %w[
      user blog_post ruby_web_framework
      blog-post ruby-web-framework
      blog-posts ruby-web-frameworks
      this?_1$#@Is^2>a[][[+3)]]test;'\
      user_model user_controller user_helper
    ]
  end

  describe 'class methods' do
    context '.route' do
      let(:actual) { examples.map &subject.method(:route) }

      it 'should correctly inflect strings' do
        expected = %w[
          user blog-post ruby-web-framework
          blog-post ruby-web-framework
          blog-posts ruby-web-frameworks
          this-1-is-2-a-3-test
          user-model user-controller user-helper
        ]
        expect(expected).to eq actual
      end
    end
    context '.resource' do
      let(:actual) { examples.map &subject.method(:resource) }

      it 'should correctly inflect strings' do
        expected = %w[
          user blog_post ruby_web_framework
          blog_post ruby_web_framework
          blog_post ruby_web_framework
          this_1_is_2_a_3_test
          user_model user_controller user_helper
        ]
        expect(expected).to eq actual
      end
    end
    context '.resources' do
      let(:actual) { examples.map &subject.method(:resources) }

      it 'should correctly inflect strings' do
        expected = %w[
          users blog_posts ruby_web_frameworks
          blog_posts ruby_web_frameworks
          blog_posts ruby_web_frameworks
          this_1_is_2_a_3_tests
          user_models user_controllers user_helpers
        ]
        expect(expected).to eq actual
      end
    end
    context '.resource_keep_inflection' do
      let(:actual) { examples.map &subject.method(:resource_keep_inflection) }

      it 'should correctly inflect strings' do
        expected = %w[
          user blog_post ruby_web_framework
          blog_post ruby_web_framework
          blog_posts ruby_web_frameworks
          this_1_is_2_a_3_test
          user_model user_controller user_helper
        ]
        expect(expected).to eq actual
      end
    end
    context '.constant' do
      let(:actual) { examples.map &subject.method(:constant) }

      it 'should correctly inflect strings' do
        expected = %w[
          User BlogPost RubyWebFramework
          BlogPost RubyWebFramework
          BlogPost RubyWebFramework
          This1Is2A3Test
          UserModel UserController UserHelper
        ]
        expect(expected).to eq actual
      end
    end
    context '.constant_pluralize' do
      let(:actual) { examples.map &subject.method(:constant_pluralize) }

      it 'should correctly inflect strings' do
        expected = %w[
          Users BlogPosts RubyWebFrameworks
          BlogPosts RubyWebFrameworks
          BlogPosts RubyWebFrameworks
          This1Is2A3Tests
          UserModels UserControllers UserHelpers
        ]
        expect(expected).to eq actual
      end
    end
    context '.controller' do
      let(:actual) { examples.map &subject.method(:controller) }

      it 'should correctly inflect strings' do
        expected = %w[
          user_controller blog_post_controller ruby_web_framework_controller
          blog_post_controller ruby_web_framework_controller
          blog_post_controller ruby_web_framework_controller
          this_1_is_2_a_3_test_controller
          user_model_controller user_controller user_helper_controller
        ]
        expect(expected).to eq actual
      end
    end
    context '.helper' do
      let(:actual) { examples.map &subject.method(:helper) }

      it 'should correctly inflect strings' do
        expected = %w[
          user_helper blog_post_helper ruby_web_framework_helper
          blog_post_helper ruby_web_framework_helper
          blog_post_helper ruby_web_framework_helper
          this_1_is_2_a_3_test_helper
          user_model_helper user_controller_helper user_helper
        ]
        expect(expected).to eq actual
      end
    end
    context '.model' do
      let(:actual) { examples.map &subject.method(:model) }

      it 'should correctly inflect strings' do
        expected = %w[
          user blog_post ruby_web_framework
          blog_post ruby_web_framework
          blog_post ruby_web_framework
          this_1_is_2_a_3_test
          user_model user_controller user_helper
        ]
        expect(expected).to eq actual
      end
    end
  end

  describe 'model attributes' do
    context 'name' do
      let(:actual) { examples.map {|e| subject.new(:model, e).name } }

      it 'should be correctly inflected' do
        expected = %w[
          user blog_post ruby_web_framework
          blog_post ruby_web_framework
          blog_post ruby_web_framework
          this_1_is_2_a_3_test
          user_model user_controller user_helper
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_name' do
      let(:actual) { examples.map {|e| subject.new(:model, e).file_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user.rb blog_post.rb ruby_web_framework.rb
          blog_post.rb ruby_web_framework.rb
          blog_post.rb ruby_web_framework.rb
          this_1_is_2_a_3_test.rb
          user_model.rb user_controller.rb user_helper.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_path' do
      let(:actual) { examples.map {|e| subject.new(:model, e).file_path } }

      it 'should be correctly inflected' do
        expected = %w[
          app/models/user.rb app/models/blog_post.rb app/models/ruby_web_framework.rb
          app/models/blog_post.rb app/models/ruby_web_framework.rb
          app/models/blog_post.rb app/models/ruby_web_framework.rb
          app/models/this_1_is_2_a_3_test.rb
          app/models/user_model.rb app/models/user_controller.rb app/models/user_helper.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_name' do
      let(:actual) { examples.map {|e| subject.new(:model, e).spec_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_spec.rb blog_post_spec.rb ruby_web_framework_spec.rb
          blog_post_spec.rb ruby_web_framework_spec.rb
          blog_post_spec.rb ruby_web_framework_spec.rb
          this_1_is_2_a_3_test_spec.rb
          user_model_spec.rb user_controller_spec.rb user_helper_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_path' do
      let(:actual) { examples.map {|e| subject.new(:model, e).spec_path } }

      it 'should be correctly inflected' do
        expected = %w[
          spec/models/user_spec.rb spec/models/blog_post_spec.rb spec/models/ruby_web_framework_spec.rb
          spec/models/blog_post_spec.rb spec/models/ruby_web_framework_spec.rb
          spec/models/blog_post_spec.rb spec/models/ruby_web_framework_spec.rb
          spec/models/this_1_is_2_a_3_test_spec.rb
          spec/models/user_model_spec.rb spec/models/user_controller_spec.rb spec/models/user_helper_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
  end

  describe 'controller attributes' do
    context 'name' do
      let(:actual) { examples.map {|e| subject.new(:controller, e).name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_controller blog_post_controller ruby_web_framework_controller
          blog_post_controller ruby_web_framework_controller
          blog_post_controller ruby_web_framework_controller
          this_1_is_2_a_3_test_controller
          user_model_controller user_controller user_helper_controller
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_name' do
      let(:actual) { examples.map {|e| subject.new(:controller, e).file_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_controller.rb blog_post_controller.rb ruby_web_framework_controller.rb
          blog_post_controller.rb ruby_web_framework_controller.rb
          blog_post_controller.rb ruby_web_framework_controller.rb
          this_1_is_2_a_3_test_controller.rb
          user_model_controller.rb user_controller.rb user_helper_controller.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_path' do
      let(:actual) { examples.map {|e| subject.new(:controller, e).file_path } }

      it 'should be correctly inflected' do
        expected = %w[
          app/controllers/user_controller.rb app/controllers/blog_post_controller.rb app/controllers/ruby_web_framework_controller.rb
          app/controllers/blog_post_controller.rb app/controllers/ruby_web_framework_controller.rb
          app/controllers/blog_post_controller.rb app/controllers/ruby_web_framework_controller.rb
          app/controllers/this_1_is_2_a_3_test_controller.rb
          app/controllers/user_model_controller.rb app/controllers/user_controller.rb app/controllers/user_helper_controller.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_name' do
      let(:actual) { examples.map {|e| subject.new(:controller, e).spec_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_controller_spec.rb blog_post_controller_spec.rb ruby_web_framework_controller_spec.rb
          blog_post_controller_spec.rb ruby_web_framework_controller_spec.rb
          blog_post_controller_spec.rb ruby_web_framework_controller_spec.rb
          this_1_is_2_a_3_test_controller_spec.rb
          user_model_controller_spec.rb user_controller_spec.rb user_helper_controller_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_path' do
      let(:actual) { examples.map {|e| subject.new(:controller, e).spec_path } }

      it 'should be correctly inflected' do
        expected = %w[
          spec/controllers/user_controller_spec.rb spec/controllers/blog_post_controller_spec.rb spec/controllers/ruby_web_framework_controller_spec.rb
          spec/controllers/blog_post_controller_spec.rb spec/controllers/ruby_web_framework_controller_spec.rb
          spec/controllers/blog_post_controller_spec.rb spec/controllers/ruby_web_framework_controller_spec.rb
          spec/controllers/this_1_is_2_a_3_test_controller_spec.rb
          spec/controllers/user_model_controller_spec.rb spec/controllers/user_controller_spec.rb spec/controllers/user_helper_controller_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
  end

  describe 'helper attributes' do
    context 'name' do
      let(:actual) { examples.map {|e| subject.new(:helper, e).name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_helper blog_post_helper ruby_web_framework_helper
          blog_post_helper ruby_web_framework_helper
          blog_post_helper ruby_web_framework_helper
          this_1_is_2_a_3_test_helper
          user_model_helper user_controller_helper user_helper
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_name' do
      let(:actual) { examples.map {|e| subject.new(:helper, e).file_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_helper.rb blog_post_helper.rb ruby_web_framework_helper.rb
          blog_post_helper.rb ruby_web_framework_helper.rb
          blog_post_helper.rb ruby_web_framework_helper.rb
          this_1_is_2_a_3_test_helper.rb
          user_model_helper.rb user_controller_helper.rb user_helper.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'file_path' do
      let(:actual) { examples.map {|e| subject.new(:helper, e).file_path } }

      it 'should be correctly inflected' do
        expected = %w[
          app/helpers/user_helper.rb app/helpers/blog_post_helper.rb app/helpers/ruby_web_framework_helper.rb
          app/helpers/blog_post_helper.rb app/helpers/ruby_web_framework_helper.rb
          app/helpers/blog_post_helper.rb app/helpers/ruby_web_framework_helper.rb
          app/helpers/this_1_is_2_a_3_test_helper.rb
          app/helpers/user_model_helper.rb app/helpers/user_controller_helper.rb app/helpers/user_helper.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_name' do
      let(:actual) { examples.map {|e| subject.new(:helper, e).spec_name } }

      it 'should be correctly inflected' do
        expected = %w[
          user_helper_spec.rb blog_post_helper_spec.rb ruby_web_framework_helper_spec.rb
          blog_post_helper_spec.rb ruby_web_framework_helper_spec.rb
          blog_post_helper_spec.rb ruby_web_framework_helper_spec.rb
          this_1_is_2_a_3_test_helper_spec.rb
          user_model_helper_spec.rb user_controller_helper_spec.rb user_helper_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
    context 'spec_path' do
      let(:actual) { examples.map {|e| subject.new(:helper, e).spec_path } }

      it 'should be correctly inflected' do
        expected = %w[
          spec/helpers/user_helper_spec.rb spec/helpers/blog_post_helper_spec.rb spec/helpers/ruby_web_framework_helper_spec.rb
          spec/helpers/blog_post_helper_spec.rb spec/helpers/ruby_web_framework_helper_spec.rb
          spec/helpers/blog_post_helper_spec.rb spec/helpers/ruby_web_framework_helper_spec.rb
          spec/helpers/this_1_is_2_a_3_test_helper_spec.rb
          spec/helpers/user_model_helper_spec.rb spec/helpers/user_controller_helper_spec.rb spec/helpers/user_helper_spec.rb
        ]
        expect(expected).to eq actual
      end
    end
  end
end