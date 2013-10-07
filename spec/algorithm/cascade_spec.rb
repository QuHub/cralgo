require 'spec_helper'

describe Algorithm::Cascade do
  describe '#render' do
    it 'converts activation table into gates' do
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
        c c . . . . . .
        . c . . . . . .
        . + c . . . . .
        . . c . . . . .
        . . + c . . c .
        . . . n . . c .
        . . . + c c + c
        . . . . n c . c
        . . . . + . . +
        . . . . . + . .
        + . . . . . . .
      TXT
    end

    it 'converts activation table into gates' do
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
        . c . . . . .
        . c . . . . .
        . + c . . c .
        . . n . . c .
        . . + c c + c
        . . . n c . c
        . . . + . . +
        . . . . + . .
        + . . . . . .
      TXT
    end

    it 'converts activation table into gates', :dev => true do
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
        . n c n c n c n c c
      TXT
      outputs = text_grid <<-TXT
        1 0 1 0 0 0 1 0 0 1
        0 1 0 0 1 1 0 0 1 0
        0 0 0 1 0 0 0 1 0 0
      TXT

      subject = described_class.new inputs, outputs
      subject.render.inspect.gsub('-','.').should == strip_leading(<<-TXT)
        c . . . . . . . . . . . . . . . . . . . . . . . . . .
        . c . . . . . . . . . . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . . . . . . . . . . . . .
        . n . . . . . . . . . . . . . . . . . . . . . . . . .
        . + c . . . . . . . . . . . . . . . . . . . . . . . .
        . . n . . . . . . . . . . . . . . . . . . . . . . . .
        . . + c . . . . . . . . . . . . . . . . . c . . . . .
        . . . n . . . . . . . . . . . . . . . . . c . . . . .
        . . . + c . . . . . . . . . . . . . . . . + c . . . .
        . . . . n . . . . . . . . . . . . . . . . . c . . . .
        . . . . + c . . . . . . . c . . . . . . . . + c . . .
        . . . . . n . . . . . . . c . . . . . . . . . n . . .
        . . . . . + c . . . . . . + c . . . . . . . . + c . .
        . . . . . . n . . . . . . . c . . . . . . . . . n . .
        . . . . . . + c . . c . . . + c . . c . . . . . + c .
        . . . . . . . n . . c . . . . n . . c . . . . . . n .
        . . . . . . . + c c + c c . . + c c + c c . . . . + c
        . . . . . . . . n c . n c . . . n c . n c . . . . . c
        + . . . . . . . . + . . . . . . . + . . . . . . . . +
        . . . . . . . . + . . . + . . . + . . . + . . . . . .
        . . . . . . . . . . . + . . . . . . . + . . . . . . .
      TXT
    end
  end
end


