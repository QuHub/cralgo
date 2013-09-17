require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe '4gt10' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/4gt10_22.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        c - - - -
        n c - - -
        c n - c -
        c n c n c
      TABLE
    end

    let(:inputs) {algorithm.activation_table.map(&activation)}
    let(:outputs) {function.outputs}
    let(:cascade) {Algorithm::Cascade.new(inputs, outputs)}

    it 'renders the quantum cascade' do
      cascade.render.inspect.should == strip_leading(<<-TXT)
        c . . c . . . . . .
        n . . c . . . . . .
        + c . + c . . c . .
        . c . . n . . c . .
        . + c . + c c + c c
        . . c . . n c . n c
        . . + . . + + . + +
      TXT
    end
  end
end
