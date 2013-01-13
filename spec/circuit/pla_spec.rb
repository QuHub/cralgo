require 'spec_helper'

describe Circuit::Pla do
  subject {described_class.new('./spec/fixtures/hwb4.pla')}

  it 'reads function name' do
    subject.function.should == 'hwb4'
  end

  it 'reads number of variables' do
    subject.number_inputs.should == 4
    subject.number_outputs.should == 4
  end

  it 'reads input cubes' do
    subject.inputs.should == [
      [0,0,0,0], [0,0,0,1], [0,0,1,0], [0,0,1,1], [0,1,0,0], [0,-1,0,1], [0,1,1,0], [0,1,1,1],
      [1,0,-1,-1], [1,0,0,1], [1,0,1,0], [1,0,1,1], [1,1,0,0], [1,1,0,1], [1,1,1,0], [1,1,1,1]
    ]
  end

  it 'reads output cubes' do
    subject.outputs.should == [
      [0,0,0,0], [1,0,0,0], [0,0,0,1], [1,1,0,0], [0,0,1,0], [0,1,0,1], [1,0,0,1], [1,1,1,0],
      [0,1,0,0], [0,1,1,0], [1,0,1,0], [0,1,1,1], [0,0,1,1], [1,0,1,1], [1,1,0,1], [1,1,1,1]
    ]
  end
end



