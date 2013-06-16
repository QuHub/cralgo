require 'spec_helper'

describe Algorithm::Grid do
  subject { described_class.new(3,4,'.') }
  describe '#initialize' do
    it 'creates a grid with width and height' do
      subject.inspect.should == strip_leading(<<-TEXT)
        ...
        ...
        ...
        ...
      TEXT
    end
  end

  describe '#insert_row' do
    it 'adds a new row at the specified location using default initializer' do
      subject.initializer = '-'
      subject.insert_row(2).inspect.should == strip_leading(<<-TEXT)
        ...
        ...
        ---
        ...
        ...
      TEXT
      subject.width.should == 3
      subject.height.should == 5
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_row(2, '*').inspect.should == strip_leading(<<-TEXT)
        ...
        ...
        ***
        ...
        ...
      TEXT
      subject.width.should == 3
      subject.height.should == 5
    end
  end

  describe '#insert_col' do
    it 'adds a new row at the specified location using default initializer' do
      subject.initializer = '-'
      subject.insert_col(2).inspect.should == strip_leading(<<-TEXT)
        ..-.
        ..-.
        ..-.
        ..-.
      TEXT
      subject.width.should == 4
      subject.height.should == 4
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_col(2, '*').inspect.should == strip_leading(<<-TEXT)
        ..*.
        ..*.
        ..*.
        ..*.
      TEXT
      subject.width.should == 4
      subject.height.should == 4
    end

    it 'adds a new row at the specified location using passed in array' do
      subject.insert_col(2, ['1', '2', '3', '4']).inspect.should == strip_leading(<<-TEXT)
        ..1.
        ..2.
        ..3.
        ..4.
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
end
