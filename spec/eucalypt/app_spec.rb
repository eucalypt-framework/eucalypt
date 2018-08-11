require 'spec_helper'

describe 'Core application file' do
  subject { Eucalypt::APP_FILE }

  context 'should be frozen' do
    it { expect { subject.gsub! /.*/, '' }.to raise_error FrozenError }
  end
end

describe 'Eucalypt.app?' do
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