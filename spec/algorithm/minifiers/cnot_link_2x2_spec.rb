require 'spec_helper'

describe Minifiers::CnotLink2x2 do
  let(:grid) { <<-GRID
    c . . c . . . .
    n . . c . . . .
    + c . + c . c .
    . c . . n . c .
    . + c . + c + c
    . . c . . . . .
    . . + . . + . +
    GRID
  }
  subject { described_class.new(grid, 1) }

  describe '#build_markers' do
    it 'mark location of used bits' do
      subject.build_markers.should == [
        ['cn', [0,1,2]] ,
        ['cc', [2,3,4]],
        ['cc', [4,5,6]],
        ['cc', [0,1,2]],
        ['cn', [2,3,4]],
        ['c',  [4,6]],
        ['cc', [2,3,4]],
        ['c',  [4,6]],
      ]
    end
  end

  describe '#reduce' do
    it 'recduces qualifed minterms with replacement pattern' do
      subject.reduce
      subject.grid.inspect.should == strip_leading(<<-GRID)
        c . . c . .
        n . . c . .
        + c . + c c
        . c . . n c
        . + c . . .
        . . c . . .
        . . + . + +
      GRID
    end
  end
end

