require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe 'alu_9' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/alu_9.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      #algorithm.activation_table.map(&activation).transpose.map(&joinit).should == decode(<<-TABLE)
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        n - - - - - - - - - - - c - - -
        n - - - - - - c - - - - n - - c
        n - - - c - - n - - c - n - c n
        n - c - n c - n - c n c n c c n
        n c n c c n c n c n c n n c c n
      TABLE
    end

    let(:inputs) {algorithm.activation_table.map(&activation)}
    let(:outputs) {function.outputs}
    let(:cascade) {Algorithm::Cascade.new(inputs, outputs)}

    it 'renders the quantum cascade' do
      cascade.render.inspect.should == strip_leading(<<-TXT)
        n . . . . . . . . . . . . . n . . . . . . . . . . . c . . . . . . . . c . . .
        n . . . . . . . . . . . . . c . . . . . . . . . . . n . . . . . . . . c . . .
        + c . . . . . . c . . . . . + c . . . . . c . . . . + c . . . . c . . + c . .
        . n . . . . . . c . . . . . . n . . . . . c . . . . . n . . . . c . . . n . .
        . + c . . c . . + c . c . . . + c . . c . + c . c . . + c . c . + c . . + c .
        . . n . . c . . . n . c . . . . n . . c . . n . c . . . n . c . . c . . . n .
        . . + c c + c c . + c + c c . . + c c + c . + c + c . . + c + c . + c . . + c
        . . . n c . n c . . c . n c . . . n c . n . . c . n . . . n . c . . c . . . n
        . . . + + . + + . . + . + + . . . + + . + . . + . + . . . + . + . . + . . . +
      TXT
    end


    it 'minimizes the quantum casacde, without Grid3x3' do
      cascade.stub(:minimizers => [Minifiers::Grid2x2, Minifiers::CnotLink2x2])
      cascade.minimize.inspect.should == strip_leading(<<-TXT)
       n . . . . . n . . . . . . . . . c . . . . . . . . c . . .
       n . . . . . c . . . . . . . . . n . . . . . . . . c . . .
       + c c . . . + c . . . c . . . . + c . . . . c . . + c . .
       . n c . . . . n . . . c . . . . . n . . . . c . . . n . .
       . . + c . c . + c c . + c . c . . + c . c . + c . . + c .
       . . . n . c . . n c . . n . c . . . n . c . . c . . . n .
       . . . + c . . . . + c . + c + c . . + c + c . + c . . + c
       . . . . c . . . . . n . . c . n . . . n . c . . c . . . n
       . + . . + + . . + . + . . + . + . . . + . + . . + . . . +
      TXT
    end
    it 'minimizes the quantum casacde' do
      cascade.minimize.inspect.should == strip_leading(<<-TXT)
       n . . . . . n . . . . . . . . . c . . . . . . . . c . . .
       n . . . . . c . . . . . . . . . n . . . . . . . . c . . .
       + c c . . . + c . . . c . . . . + c . . . . c . . + c . .
       . n c . . . . n . . . c . . . . . n . . . . c . . . n . .
       . . + c . c . + c c . + c . c . . + c . c . + c . . + c .
       . . . n . c . . n c . . n . c . . . n . c . . c . . . n .
       . . . + c . . . . + c . + c + c . . + c + c . + c . . + c
       . . . . c . . . . . n . . c . n . . . n . c . . c . . . n
       . + . . + + . . + . + . . + . + . . . + . + . . + . . . +
      TXT
    end
  end
end
