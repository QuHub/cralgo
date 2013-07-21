require 'spec_helper'

describe Algorithm::Cascade do
  describe '#gates' do
    it 'initializes the gates grid from inputs' do
      inputs = text_grid <<-TXT
        c - - -
        . c - -
        . c - -
        . n - c
        . n c c
      TXT

      outputs = text_grid <<-TXT
        0 1 0 1
        0 0 1 0
        1 0 0 0
      TXT
      described_class.new(inputs, outputs).grid.inspect.should ==
        "c - - -\n. c - -\n. c - -\n. n - c\n. n c c"
    end
  end

  describe '#with_top_control_line' do
    subject = described_class.new([], [])
    it "adds an additonal control line if (n or c) are preceeded by a '-'" do
      subject.with_top_control_line(%w(- - c n)).should == %w(- c c n)
    end
  end
  describe '#render' do
    it 'converts activation table into gates', :dev => true do
      inputs = text_grid <<-TXT
        c - - -
        . c - -
        . c - -
        . n - c
        . n c c
      TXT
      outputs = text_grid <<-TXT
        0 1 0 1
        0 0 1 0
        1 0 0 0
      TXT

      subject = described_class.new inputs, outputs
      # NOTE: This is a temporary solution and it does not represent the
      # actual layout; the intersection points above the c|n should really
      # have the don't care symbol '-'.
      subject.render.inspect.should == strip_leading(<<-TXT)
        c c - - - - - -
        . C - - - - - -
        . + c - - - - -
        . . C - - - - -
        . . + c - - c -
        . . . N - - c -
        . . . . . . + c
        . . . + c c . -
        . . . . N c . c
        . . . . + . . +
        . . . . . + . .
        + . . . . . . .
      TXT
    end

    it 'converts activation table into gates', :dev => true do
      inputs = text_grid <<-TXT
        c . . .
        . c - -
        . c - -
        . n - c
        . n c c
      TXT
      outputs = text_grid <<-TXT
        0 1 0 1
        0 0 1 0
        1 0 0 0
      TXT

      subject = described_class.new inputs, outputs
      # NOTE: This is a temporary solution and it does not represent the
      # actual layout; the intersection points above the c|n should really
      # have the don't care symbol '-'.
      subject.render.inspect.should == strip_leading(<<-TXT)
        c . . . . . .
        . c - - - - -
        . c - - - - -
        . + c - - c -
        . . n - - c -
        . . + c c . -
        . . . . . + c
        . . . n c . c
        . . . + . . +
        . . . . + . .
        + . . . . . .
      TXT
    end

    it 'converts activation table into gates' do
      inputs = text_grid <<-TXT
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
        . r c n c n c n c c
      TXT
      outputs = text_grid <<-TXT
        1 0 1 0 0 0 1 0 0 1
        0 1 0 0 1 1 0 0 1 0
        0 0 0 1 0 0 0 1 0 0
      TXT

      subject = described_class.new inputs, outputs
      # NOTE: This is a temporary solution and it does not represent the
      # actual layout; the intersection points above the c|n should really
      # have the don't care symbol '-'.
      subject.render.inspect.gsub('-','.').should == strip_leading(<<-TXT)
        c . . . . . . . . . . . . . . . . . . . . . . . . . .
        . c . . . . . . . . . . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . . . . . . .
        . n . . . . . . . . . . . . . . . . . . . . . . . . .
        . + c . . . . . . . . . . . . . . . . . . . . . . . .
        . . n . . . . . . . . . . . . . . . . . . . . . . . .
        . . + c . . . . . . . . . . . . . . . . . c . . . . .
        . . . n . . . . . . . . . . . . . . . . . c . . . . .
        . . . + c . . . . . . . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . + c . . . .
        . . . . n . . . . . . . . . . . . . . . . . c . . . .
        . . . . + c . . . . . . . c . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . . + c . . .
        . . . . . n . . . . . . . c . . . . . . . . . n . . .
        . . . . . + c . . . . . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . + c . . . . . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . . . + c . .
        . . . . . . n . . . . . . . c . . . . . . . . . n . .
        . . . . . . + c . . c . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . + c . . c . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . . . . + c .
        . . . . . . . n . . c . . . . n . . c . . . . . . n .
        . . . . . . . . . . . . . . . . . . . . . . . . . + c
        . . . . . . . + c c . . . . . . . . . . . . . . . . .
        . . . . . . . . . . + c c . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . + c c . . . . . . . . .
        . . . . . . . . . . . . . . . . . . + c c . . . . . .
        . . . . . . . . n c . n c . . . n c . n c . . . . . c
        + . . . . . . . . + . . . . . . . + . . . . . . . . +
        . . . . . . . . + . . . + . . . + . . . + . . . . . .
        . . . . . . . . . . . + . . . . . . . + . . . . . . .
      TXT
    end
  end
end


__END__

c . . .
. c - -
. c - -
. n - c
. n c c


a   c . . .
b   . c - -
c   . c - C
d   . n C c
e   . n c c
o   + . . .


a   c . . . . . .
b   . c . . - - .
c   . c . . - . .
.   . + c . . C .
d   . . n . . c .
.   . . + c C . .
.   . . . . . + c
e   . . . n c . c
o   + . . + + . +


a   c . . . .
b   . c . - -
c   . c . - .
.   . + c . C
d   . . n C c
e   . . n c c
o   + . . . .












