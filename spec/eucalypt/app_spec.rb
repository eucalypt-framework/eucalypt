require 'spec_helper'

describe Eucalypt do
  describe APP_FILE do
    subject { Eucalypt::APP_FILE }

    context 'should be frozen' do
      it { expect { subject.gsub! /.*/, '' }.to raise_error FrozenError }
    end
  end
  describe '.app?' do
    before { Temporary.create_app }
    after { Temporary.clear }

    context 'when core application file exists' do
      it do
        tmp { expect(Eucalypt.app? '.').to be true }
      end
    end
    context "when core application file doesn't exist" do
      it do
        tmp do
          FileUtils.rm Eucalypt::APP_FILE
          expect(Eucalypt.app? '.').to be false
        end
      end
    end
  end
  describe '.console?' do
    context 'while $CONSOLE is set' do
      context 'to true' do
        before { ENV['CONSOLE'] = 'true' }

        it { expect(Eucalypt.console?).to be true }
      end
      context 'to false' do
        before { ENV['CONSOLE'] = 'false' }

        it { expect(Eucalypt.console?).to be true }
      end
    end
    context 'while $CONSOLE is not set' do
      before { ENV['CONSOLE'] = nil }

      it { expect(Eucalypt.console?).to be false }
    end
  end
end