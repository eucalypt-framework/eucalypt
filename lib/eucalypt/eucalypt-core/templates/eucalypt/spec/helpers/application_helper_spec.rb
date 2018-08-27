require_relative '../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  it "should expect true to be false" do
    expect(true).to be false
  end
end