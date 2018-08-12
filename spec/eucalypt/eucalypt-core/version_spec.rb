require 'spec_helper'

describe Eucalypt::CLI do
  context 'Version' do
    before { Temporary.create_app }
    after { Temporary.clear }

    it 'should display the correct version' do
      output = tmp { execute 'version' }
      expect(output.chomp).to eq Eucalypt::VERSION
    end
  end
end