require 'spec_helper'

describe Circuit do
  subject {Circuit.new('./spec/fixtures/hwb4_49.real')}

  it 'reads function name' do
    subject.function.should == 'hwb4'
  end

  it 'reads variables' do
    subject.variables.should == %w(a b c d)
    subject.inputs.should == %w(a b c d)
  end

  it 'reads number of variables' do
    subject.number_of_variables.should == 4
  end

  it 'reads libary name, number of gates and quantum cost' do
    subject.library.should == 'MCT'
    subject.num_gates.should == 17
    subject.cost.should == 65
  end
  
end
