require 'spec_helper'

describe Circuit do
  subject {Circuit.new('./spec/fixtures/hwb4_49.real')}

  it 'reads function name' do
    subject.function.should == 'hwb4'

  end
end
