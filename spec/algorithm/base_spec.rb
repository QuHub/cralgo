require 'spec_helper'

describe Algorithm::Base do
  subject{described_class.new(function)}

  let(:function) {double}

  describe '#encode' do
    it 'encodes each pair of terms according to table 2' do
      function.stub(:inputs => [[0,1,0,0], [1,0,-1,0], [1,1,1,1]])
      subject.encoded_inputs.map{|a| a.map(&:encoding)}.should == [[3,3,2,2], [4, 4, 8, 8], [5,5,5,5]]
    end

    it 'encodes odd number of variables' do
      function.stub(:inputs => [[0,1,0,0,1], [1,0,-1,0,-1], [1,1,1,1,0]])
      subject.encoded_inputs.map{|a| a.map(&:encoding)}.should == [[3,3,2,2,1], [4, 4,8,8,-1], [5,5,5,5,0]]
    end

    context '4gt10' do
      it "encodes inputs correctly for 4gt10 function" do
        function.stub(:inputs => [[0,1,0,0], [1,0,-1,0], [1,1,1,1]])
        subject.encoded_inputs.map{|a| a.map(&:encoding)}.should == [[3,3,2,2], [4, 4, 8, 8], [5,5,5,5]]
      end
    end
  end
end
