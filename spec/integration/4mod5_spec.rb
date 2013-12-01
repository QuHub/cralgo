require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe '4mod5' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/4mod5.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        n - c -
        n c n c
        n n c c
        n c n c
      TABLE
    end

    let(:inputs) {algorithm.activation_table.map(&activation)}
    let(:outputs) {function.outputs}
    let(:cascade) {Algorithm::Cascade.new(inputs, outputs)}

    # NOTE: the bit row 0, column 1 should be 'n'
    it 'renders the quantum cascade' do
      cascade.render.inspect.should == strip_leading(<<-TXT)
        n . . n . . c . . c . .
        n . . c . . n . . c . .
        + c . + c . + c . + c .
        . n . . n . . c . . c .
        . + c . + c . + c . + c
        . . n . . c . . n . . c
        . . + . . + . . + . . +
      TXT
    end


    it 'minimizes the quantum casacde, without Grid3x3' do
      cascade.stub(:minimizers => [Minifiers::Grid2x2, Minifiers::CnotLink2x2])
      cascade.minimize.inspect.should == strip_leading(<<-TXT)
       n . . n . . c . . c . .
       n . . c . . n . . c . .
       + c . + c . + c . + c .
       . n . . n . . c . . c .
       . + c . + c . + c . + c
       . . n . . c . . n . . c
       . . + . . + . . + . . +
      TXT
    end

    it 'minimizes the quantum casacde' do
      cascade.minimize.inspect.should == strip_leading(<<-TXT)
       . . . n . . . . c
       c . c . . c . . .
       . . . . . . . . .
       . n . . . . . c .
       . + . c . . . + c
       + c + . + + + c .
       . . . + . . . . +
      TXT
    end
  end
end
