require 'spec_helper'

describe Algorithm::Minterm do
  describe 'render', :dev => true do
    it "does not add ancilla bits for single controls" do
      klass = described_class.new(%w(c . .), %w(1 0 0))
      klass.cascade.should == [%w(c . . + . .)]
    end

    it "adds ancilla bits for two controls" do
      klass = described_class.new(%w(c c .), %w(1 0 0))
      klass.cascade.should == [%w(c c + . . . .), %w(. . c . + . .)]
    end
  end
end
