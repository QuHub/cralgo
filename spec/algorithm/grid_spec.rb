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
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_row(2, '*').inspect.should == strip_leading(<<-TEXT)
        ...
        ...
        ***
        ...
        ...
      TEXT
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
    end

    it 'adds a new row at the specified location using passed in initializer' do
      subject.insert_col(2, '*').inspect.should == strip_leading(<<-TEXT)
        ..*.
        ..*.
        ..*.
        ..*.
      TEXT
    end
  end
end
