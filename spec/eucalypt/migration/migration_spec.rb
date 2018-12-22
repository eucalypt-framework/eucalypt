require 'spec_helper'

describe Eucalypt do
  describe Eucalypt::Migration do
    context 'Types' do
      before { Temporary.create_app }
      after { Temporary.clear }

      it do
        output = tmp { execute 'migration types' }
        expect(output).to include *Migration::Validation::COLUMN_TYPES.map(&:to_s)
      end
    end
  end
end