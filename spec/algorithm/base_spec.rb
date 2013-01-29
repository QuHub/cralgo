require 'spec_helper'

describe Algorithm::Base do
  subject{described_class.new(function)}

  def values
    lambda {|arr| arr.map(&:encoding)}
  end

  describe '#encoded_inputs' do
    let(:function) {double}
    it 'encodes each pair of terms according to table 2' do
          function.stub(:inputs => [[0,1,0,0], [1,0,-1,0], [1,1,1,1]])
          subject.encoded_inputs.map(&values).should == [[3,3,2,2], [4, 4, 8, 8], [5,5,5,5]]
    end

    it 'encodes odd number of variables' do
      function.stub(:inputs => [[0,1,0,0,1], [1,0,-1,0,-1], [1,1,1,1,0]])
      subject.encoded_inputs.map(&values).should == [[3,3,2,2,1], [4, 4,8,8,-1], [5,5,5,5,0]]
    end
  end


  describe "groupd_by" do
    let(:function) {Circuit::Pla.new('./spec/fixtures/paper_example.pla')}

  end

  describe '#indexed_inputs' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/paper_example.pla')}

    it "creates an indexed list of encoded values according to Table2" do
      subject.encoded_inputs.map(&values).should == [
        [7, 7, 10, 10, 10, 10, 10, 10, 10, 10, -1], 
        [9, 9, 8, 8, 2, 2, 3, 3, 4, 4, 1], 
        [9, 9, 8, 8, 3, 3, 4, 4, 2, 2, 1], 
        [9, 9, 8, 8, 2, 2, 2, 2, 2, 2, 1], 
        [9, 9, 8, 8, 2, 2, 3, 3, 5, 5, 1], 
        [9, 9, 8, 8, 2, 2, 2, 2, 3, 3, 1], 
        [9, 9, 8, 8, 2, 2, 3, 3, 4, 4, 0], 
        [9, 9, 8, 8, 2, 2, 2, 2, 2, 2, 0], 
        [9, 9, 8, 8, 2, 2, 3, 3, 5, 5, 0], 
        [9, 9, 8, 8, 2, 2, 2, 2, 3, 3, 0]
      ]

      subject.sorted_inputs.map(&values).should == [
        [7, 7, 10, 10, 10, 10, 10, 10, 10, 10, -1], 
        [9, 9, 8, 8, 2, 2, 2, 2, 2, 2, 0], 
        [9, 9, 8, 8, 2, 2, 2, 2, 2, 2, 1], 
        [9, 9, 8, 8, 2, 2, 2, 2, 3, 3, 0],
        [9, 9, 8, 8, 2, 2, 2, 2, 3, 3, 1], 
        [9, 9, 8, 8, 2, 2, 3, 3, 4, 4, 0], 
        [9, 9, 8, 8, 2, 2, 3, 3, 4, 4, 1], 
        [9, 9, 8, 8, 2, 2, 3, 3, 5, 5, 0], 
        [9, 9, 8, 8, 2, 2, 3, 3, 5, 5, 1], 
        [9, 9, 8, 8, 3, 3, 4, 4, 2, 2, 1], 
      ]
    end
  end
end
