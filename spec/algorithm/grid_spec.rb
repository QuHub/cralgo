require 'spec_helper'

describe Algorithm::Grid do
  subject { described_class.new(3,4,'.') }
  describe '#initialize' do
    it 'creates a grid with width and height' do
      subject.inspect.should == strip_leading(<<-TEXT)
        . . .
        . . .
        . . .
        . . .
      TEXT
    end
  end

  describe '#insert_row' do
    it 'adds a new row at the specified location using default initializer' do
      subject.initializer = '-'
      subject.insert_row(2).inspect.should == strip_leading(<<-TEXT)
        . . .
        . . .
        - - -
        . . .
        . . .
      TEXT
      subject.width.should == 3
      subject.height.should == 5
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_row(2, '*').inspect.should == strip_leading(<<-TEXT)
        . . .
        . . .
        * * *
        . . .
        . . .
      TEXT
      subject.width.should == 3
      subject.height.should == 5
    end
  end

  describe '#insert_col' do
    it 'adds a new row at the specified location using default initializer' do
      subject.initializer = '-'
      subject.insert_col(2).inspect.should == strip_leading(<<-TEXT)
        . . - .
        . . - .
        . . - .
        . . - .
      TEXT
      subject.width.should == 4
      subject.height.should == 4
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_col(2, '*').inspect.should == strip_leading(<<-TEXT)
        . . * .
        . . * .
        . . * .
        . . * .
      TEXT
      subject.width.should == 4
      subject.height.should == 4
    end

    it 'adds a new row at the specified location using passed in array' do
      subject.insert_col(2, ['1', '2', '3', '4']).inspect.should == strip_leading(<<-TEXT)
        . . 1 .
        . . 2 .
        . . 3 .
        . . 4 .
      TEXT
      subject.width.should == 4
      subject.height.should == 4
    end

    it 'raises error if the input array is less in height' do
      expect {
        subject.insert_col(2, ['1', '2', '3'])
      }.to raise_error ArgumentError
    end

    it 'raises error if the input array is more in height' do
      expect {
        subject.insert_col(2, ['1', '2', '3', '4', '5'])
      }.to raise_error ArgumentError
    end
  end

  describe '#col' do
    subject {described_class.new(0,3,'.')}
    it 'returns the specified col' do
      subject.insert_col(-1, [1,2,3])
      subject.insert_col(-1, [5,6,7])
      subject.insert_col(-1, ['a', 'b', 'c'])
      subject.col(0).should == [1,2,3]
      subject.col(1).should == [5,6,7]
      subject.col(2).should == ['a', 'b', 'c']
    end

    it 'raises an error if index out of range' do

    end
  end
end
