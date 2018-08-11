require 'spec_helper'

describe Helpers::Migration do
  subject { Helpers::Migration.new title: 'test', template: 'test' }
  before { Temporary.create_app }
  after { Temporary.clear }

  context '#exists?' do
    context 'when migration exists with the same name' do
      it do
        tmp do
          FileUtils.mkdir_p subject.base
          expect(subject.exists?).to be false
        end
      end
    end
    context "when migration doesn't exist with the same name" do
      it do
        tmp do
          execute 'migration blank test'
          expect(subject.exists?).to be true
        end
      end
    end
  end
end

describe Helpers::Migration::Validation do
  subject { Helpers::Migration::Validation }

  context '.valid_declaration?' do
    context 'when the column declaration is valid' do
      let :all_valid do
        columns = %w[a a_b a0 a_b_0 0_a]
        declarations = columns.map {|c| subject::COLUMN_TYPES.map {|t| "#{c}:#{t}"}}.flatten
        declarations.map {|d| subject.valid_declaration? d}
      end

      it { expect(all_valid).to all be true }
    end
    context 'when the column declaration is invalid' do
      let :all_valid do
        columns = %w[, . ; -]
        declarations = columns.map {|c| subject::COLUMN_TYPES.map {|t| "#{c}:#{t}"}}.flatten
        declarations.map {|d| subject.valid_declaration? d}
      end

      it { expect(all_valid).to all be false }
    end
  end
  context '.valid_type?' do
    context 'when the given type is valid' do
      let :results do
        results = subject::COLUMN_TYPES.map &:to_s
        results.map {|t| subject.valid_type?(t) }
      end

      it { expect(results).to all be true }
    end
    context 'when the given type is invalid' do
      let :results do
        types = 1000.times.map { /[a-z_][a-z_][a-z_]+/.random_example }
        types.reject! {|t| subject::COLUMN_TYPES.map(&:to_s).include? t}
        results = []
        types.map {|t| silence { results << subject.valid_type?(t) } }
        results
      end

      it { expect(results).to all be false }
    end
  end
  context '#any_invalid?' do
    context 'when all columns are valid' do
      let :any_invalid do
        declarations = 1000.times.map { /([A-Za-z0-9_]+){4}/.random_example }
        declarations.map! {|c| "#{c}:#{subject::COLUMN_TYPES.sample}" }
        invalid = nil
        silence { invalid = subject.new(declarations).any_invalid? }
        invalid
      end

      it { expect(any_invalid).to be false }
    end
    context 'when there are invalid columns' do
      let :any_invalid do
        declarations = %w[, . : ? -].map {|c| "#{c}:#{subject::COLUMN_TYPES.sample}" }
        invalid = nil
        silence { invalid = subject.new(declarations).any_invalid? }
        invalid
      end

      it { expect(any_invalid).to be true }
    end
  end
end