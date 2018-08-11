require 'spec_helper'
require_relative 'cli'

describe Helpers::Gemfile do
  subject { Helpers::Gemfile }
  before { Temporary.create_app }
  after { Temporary.clear }
  let(:args) { tmp { ['add', 'gemfile_spec', Dir.pwd, '-g', "gem_1:~> 1.3", "gem_2:0.1.0"] } }

  context '.add' do
    context "when gems aren't already present in Gemfile" do
      before { @contents = String.new }

      context 'description' do
        it 'should be inserted' do
          tmp do
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).not_to include '# gemfile_spec'
            GemfileCLI.start args
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).to include '# gemfile_spec'
          end
        end
      end
      context 'gem' do
        it 'should be inserted' do
          tmp do
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).not_to include "gem 'gem_1'", "gem 'gem_2'"
            GemfileCLI.start args
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).to include "gem 'gem_1'", "gem 'gem_2'"
          end
        end
      end
      context 'version' do
        it 'should be inserted' do
          tmp do
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).not_to include "gem 'gem_1', '~> 1.3'", "gem 'gem_2', '0.1.0'"
            GemfileCLI.start args
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents).to include "gem 'gem_1', '~> 1.3'", "gem 'gem_2', '0.1.0'"
          end
        end
      end
    end
    context 'when gems are already present in the Gemfile' do
      context 'description' do
        it "shouldn't be inserted" do
          tmp do
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan('# gemfile_spec').size).to eq 0
            10.times { GemfileCLI.start args }
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan('# gemfile_spec').size).to eq 1
          end
        end
      end
      context 'gem' do
        it "shouldn't be inserted" do
          tmp do
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan(/gem \'(gem_1|gem_2)\'/).size).to eq 0
            10.times { GemfileCLI.start args }
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan(/gem \'(gem_1|gem_2)\'/).size).to eq 2
          end
        end
      end
      context 'version' do
        it "shouldn't be inserted" do
          tmp do
            GemfileCLI.start args
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan(/gem \'(gem_1|gem_2)\'\, \'.*\'/).size).to eq 2
            10.times { GemfileCLI.start args }
            File.open('Gemfile') {|f| @contents = f.read}
            expect(@contents.scan(/gem \'(gem_1|gem_2)\'\, \'.*\'/).size).to eq 2
          end
        end
      end
    end
  end
  context '.include?' do
    context 'when gem is present in Gemfile' do
      before { @contents = String.new }

      it { tmp { expect(subject.include? %w[gem_1 gem_2], Dir.pwd).to be false } }
    end
    context "when gem isn't present in Gemfile" do
      before { @contents = String.new }

      it do
        tmp do
          GemfileCLI.start args
          expect(subject.include? %w[gem_1 gem_2], Dir.pwd).to be true
        end
      end
    end
  end
end