require 'spec_helper'
require 'eucalypt/static'

describe Static do
  let(:resources) { File.join __dir__, 'resources' }

  context 'when not all file types are valid' do
    let(:invalid) { File.join resources, 'invalid' }
    let(:static) { Static.new invalid }
    after(:each) { Dir.glob File.join('**', 'invalid.*'), &File.method(:delete) }

    it do
      FileUtils.touch File.join invalid, "invalid.#{/7@_[A-Za-z0-9]{3}/.random_example}"
      expect { static }.to raise_error TypeError
    end
  end
  context 'when all file types are valid' do
    let(:valid) { File.join resources, 'valid' }
    let(:static) { Static.new valid }

    it 'should override files with directories' do
      expect(static.override.name).to be_a Static
    end

    context 'top-level' do
      it 'should recognize directories' do
        objects = %i[override nested empty].map &static.method(:send)
        objects.each {|object| expect(object).to be_a Static}
      end

      it 'should recognize files' do
        expect(static.top_level).to be_a Hash
      end

      it 'should display available directories and files' do
        expect(static.methods false).to include *%i[top_level override nested empty]
      end
    end
    context 'nested' do
      it 'should recognize directories' do
        expect(static.nested.nested.nested).to be_a Static
      end

      it 'should recognize files' do
        expect(static.nested.nested.nested.nested).to be_a Hash
      end

      it 'should display available directories and files' do
        expect(static.nested.nested.methods false).to include *%i[nested other file]
      end
    end
    context 'empty files' do
      context 'JSON' do
        it { expect { static.empty.json }.to raise_error JSON::ParserError }
      end
      context 'YAML' do
        it { expect(static.empty.yaml).to be_a Hash }
      end
    end
    context 'content' do
      let(:unsymbolized) { Static.new valid, symbolize: false }
      let(:symbolized) { Static.new valid, symbolize: true }

      context "unsymbolized keys" do
        %w[yaml json].each do |type|
          context type.upcase do
            context 'top-level keys' do
              it { expect(unsymbolized.content.send(type).keys).to all be_a String }
            end
            context 'nested array keys' do
              it { expect(unsymbolized.content.send(type)['array'].map(&:keys).flatten).to all be_a String }
            end
            context 'nested hash keys' do
              it {
                expect(unsymbolized.content.send(type)['hash'].keys).to all be_a String
                expect(unsymbolized.content.send(type)['hash']['1'].keys).to all be_a String
              }
            end
          end
        end
      end
      context "symbolized keys" do
        %w[yaml json].each do |type|
          context type.upcase do
            context 'top-level keys' do
              it { expect(symbolized.content.send(type).keys).to all be_a Symbol }
            end
            context 'nested array keys' do
              it { expect(symbolized.content.send(type)[:array].map(&:keys).flatten).to all be_a Symbol }
            end
            context 'nested hash keys' do
              it {
                expect(symbolized.content.send(type)[:hash].keys).to all be_a Symbol
                expect(symbolized.content.send(type)[:hash][:'1'].keys).to all be_a Symbol
              }
            end
          end
        end
      end
    end
  end
end