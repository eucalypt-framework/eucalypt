require 'spec_helper'

describe Helpers::Numeric do
  subject { Helpers::Numeric }
  let(:max) { 2**(0.size * 8 - 2) - 1 }
  let(:min) { -max }

  context '.string?' do
    context 'with negative integers' do
      it { expect(100.times.map { subject.string? rand(min..-1) }).to all be true }
    end
    context 'with positive integers' do
      it { expect(100.times.map { subject.string? rand(1..max) }).to all be true }
    end
    context 'with 0' do
      it { expect(subject.string? 0).to be true }
    end
  end
end