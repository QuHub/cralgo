require 'spec_helper'

describe Minifiers::Grid3x3 do
  shared_examples_for :grid3x3 do
    subject { described_class.new(grid, 1) }
    describe '#build_markers' do
      it 'mark location of used bits' do
        if defined?(marker)
          subject.build_markers.should == marker
        end
      end
    end

    describe '#reduce' do
      it 'recduces qualifed minterms with replacement pattern' do
        subject.reduce
        subject.grid.inspect.should == strip_leading(result)
      end
    end
  end

  it_should_behave_like :grid3x3 do
    let(:grid) { <<-GRID
      n . . n . .
      n . . c . .
      + c . + c .
      . n . . c .
      . + c . + c
      . . n . . n
      . . + . . +
    GRID
    }
    let(:marker) {
      [
        ["nn", [0, 1, 2]],
        ["cn", [2, 3, 4]],
        ["cn", [4, 5, 6]],
        ["nc", [0, 1, 2]],
        ["cc", [2, 3, 4]],
        ["cn", [4, 5, 6]],
      ]
    }
    let(:result) { <<-GRID
      . . . . n
      . c . . .
      . . . . .
      + + + c .
      . . . + c
      . . . n .
      . . . . +
    GRID
   }
  end
=begin

  it_should_behave_like :grid3x3 do
    let(:grid) { <<-GRID
      n . . n . .
      n . . c . .
      + c . + c .
      . n . . n .
      . + c . + c
      . . n . . c
      . . + . . +
    GRID
    }
    let(:marker) {
      [
        ["nn", [0, 1, 2]],
        ["cn", [2, 3, 4]],
        ["cn", [4, 5, 6]],
        ["nc", [0, 1, 2]],
        ["cn", [2, 3, 4]],
        ["cc", [4, 5, 6]],
      ]
    }
    let(:result) { <<-GRID
      . . . n
      c . c .
      . . . .
      . n . .
      . + . c
      + c + .
      . . . +
    GRID
   }
  end

  it_should_behave_like :grid3x3 do
    let(:grid) { <<-GRID
      n . c .
      n . n .
      + c + c
      . n . n
      . + . +
    GRID
    }
    let(:marker) {
      [
        ['nn', [0,1,2]] ,
        ['cn', [2,3,4]],
        ['cn', [0,1,2]],
        ['cn', [2,3,4]],
      ]
    }
    let(:result) { <<-GRID
      .
      n
      .
      n
      +
    GRID
   }
  end

  it_should_behave_like :grid3x3 do
    let(:grid) { <<-GRID
      n . c .
      n . n .
      + c + c
      . n . c
      . + . +
    GRID
    }
    let(:marker) {
      [
        ['nn', [0,1,2]] ,
        ['cn', [2,3,4]],
        ['cn', [0,1,2]],
        ['cc', [2,3,4]],
      ]
    }
    let(:result) { <<-GRID
      c . c
      . n .
      . . .
      + c +
      . + .
    GRID
   }
  end

  it_should_behave_like :grid3x3 do
    let(:grid) { <<-GRID
      n . c .
      c . c .
      + c + c
      . n . c
      . + . +
    GRID
    }
    let(:result) { <<-GRID
     . c . . . c .
     . . . c . . .
     . . . . . . .
     + + + c + + +
     . . . + . . .
    GRID
   }
  end
=end
end

