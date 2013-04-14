require 'spec_helper'

describe Algorithm::Base do
  let(:function) {Circuit::Pla.new('./spec/fixtures/paper_example.pla')}
  subject{described_class.new(function)}

  def tuple
    lambda {|arr| arr.map{|x| [x.value, x.encoding, x.b, x.activation]} }
  end

  def values
    lambda {|arr| arr.map(&:value)}
  end

  def encoding
    lambda {|arr| arr.map(&:encoding)}
  end

  def activation
    lambda {|arr| arr.map(&:activation)}
  end

  describe '#encoded_inputs' do
    let(:function) {double}
    it 'encodes each pair of terms according to table 2' do
          function.stub(:inputs => [[0,1,0,0], [1,0,-1,0], [1,1,1,1]])
          subject.encoded_inputs.map(&encoding).should == [[3,3,2,2], [4, 4, 8, 8], [5,5,5,5]]
    end

    it 'encodes odd number of variables' do
      function.stub(:inputs => [[0,1,0,0,1], [1,0,-1,0,-1], [1,1,1,1,0]])
      subject.encoded_inputs.map(&encoding).should == [[3,3,2,2,1], [4, 4,8,8,-1], [5,5,5,5,0]]
    end
  end


  def transform(table)
    table.split("\n").map{|x| x.split(" ").map(&:to_i)}.transpose
  end

  def decode(table)
    table.split("\n").map{|x| x.split(" ")}.transpose
  end

  describe '#sorted_inputs' do

    it "creates an indexed list of encoded values according to Table2" do
      subject.encoded_inputs.map(&encoding).should == transform(<<-TABLE)
         7  9  9  9  9  9  9  9  9  9 
         7  9  9  9  9  9  9  9  9  9 
        10  8  8  8  8  8  8  8  8  8 
        10  8  8  8  8  8  8  8  8  8 
        10  2  3  2  2  2  2  2  2  2 
        10  2  3  2  2  2  2  2  2  2 
        10  3  4  2  3  2  3  2  3  2 
        10  3  4  2  3  2  3  2  3  2 
        10  4  2  2  5  3  4  2  5  3 
        10  4  2  2  5  3  4  2  5  3 
        -1  1  1  1  1  1  0  0  0  0
      TABLE

      subject.sorted_inputs.map(&encoding).should == transform(<<-TABLE)
         7  9  9  9  9  9  9  9  9  9 
         7  9  9  9  9  9  9  9  9  9 
        10  8  8  8  8  8  8  8  8  8 
        10  8  8  8  8  8  8  8  8  8 
        10  2  2  2  2  2  2  2  2  3 
        10  2  2  2  2  2  2  2  2  3 
        10  2  2  2  2  3  3  3  3  4 
        10  2  2  2  2  3  3  3  3  4 
        10  2  2  3  3  4  4  5  5  2 
        10  2  2  3  3  4  4  5  5  2 
        -1  0  1  0  1  0  1  0  1  1
      TABLE
    end
  end

  describe '#activation_table' do
    it "builds the activation Table 6 from sorted_inputs" do
      subject.activation_table.transpose.map(&tuple).each {|x| p x}
      #subject.activation_table.map(&activation).should == decode(<<-TABLE)
      p decode(<<-TABLE).map {|x| x.join('')}
        c . . . . . . . . .
        . c - - - - - - - -
        . . . . . . . . . .
        . n - - - - - - - -
        . n - - - - - - - -
        . n - - - - - - - c
        . n - - - - - - - c
        . n - - - c - - - n
        . n - - - c - - - n
        . n - c - n - c - n
        . n c n c n c n c c
      TABLE
    end
  end
end
