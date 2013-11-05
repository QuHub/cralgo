require 'spec_helper'

describe Minifiers::Grid3x3 do
  let(:grid) { <<-GRID
      n . c .
      n . c .
      + c + c
      . n . n
      . + . +
    GRID
  }
  subject { described_class.new(grid, 1) }

  describe '#build_markers' do
    it 'mark location of used bits' do
      subject.build_markers.should == [
        ['nn', [0,1,2]] ,
        ['cn', [2,3,4]],
        ['cc', [0,1,2]],
        ['cn', [2,3,4]],
      ]
    end
  end

  describe '#reduce' do
    it 'recduces qualifed minterms with replacement pattern' do
      subject.reduce
      subject.grid.inspect.should == strip_leading(<<-GRID)
        . c . .
        + + + c
        . . . .
        . . . n
        . . . +
      GRID
    end
  end
end

