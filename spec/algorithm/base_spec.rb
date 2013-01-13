require 'spec_helper'

describe Algorithm::Base do
  let(:function) do
    f = double('function')
    f.stub(:inputs => [[0,1,0,0], [1,0,-1,0], [1,1,1,1]])
  end

  subject{described_class.new(function)}

  describe '#encode' do
    subject.encode.should == [[3,3,2,2], [4, 4, 8, 8], [5,5,5,5]]
  end
end
