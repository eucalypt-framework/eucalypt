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

end