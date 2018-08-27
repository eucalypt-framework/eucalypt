require_relative '../spec_helper'

describe ApplicationController do
  def app() ApplicationController end

  it "should expect true to be false" do
    expect(true).to be false
  end
end