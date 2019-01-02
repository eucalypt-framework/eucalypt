require_relative '../spec_helper'

describe MainHelper do
  include MainHelper

  it "should expect true to be false" do
    expect(true).to be false
  end
end