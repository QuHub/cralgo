require 'spec_helper'

describe Algorithm::Cascade do
  describe 'render' do
    it "does not add ancilla bits for single controls" do
      input = minterms("c..")
      output = minterms("100")
      klass = described_class.new(input, output)
      klass.circuit.should == [%w(c . . + . .)]
    end

    it "adds ancilla bits for two controls" do
      input = minterms("cc.")
      output = minterms("100")
      klass = described_class.new(input, output)
      klass.circuit.should == [%w(c c + . . . .), %w(. . c . + . .)]
    end
  end
end
