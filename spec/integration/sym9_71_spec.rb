require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe 'Sym9_71' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/sym9_71.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      #algorithm.activation_table.map(&activation).transpose.map(&joinit).should == decode(<<-TABLE)
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        n - - - - - - - - - - - - - - - - - - - c - - - - - - - - - - - - - - - n - - - - - - - - - c - - - - - - - - - - - . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
        n - - - - - - c - - - - - - - - - - - - n - - - - - - - - c - - - - - - . . . . . . . . . . . . . . . . . . . . . . n - - - - - - - - - - - - c - - - - - - - - - - . . . . .
        n c - . . . . n c - n - . . . . . . . . n c n - c . . . . n c n . . . . n c - - n - c - . . n - c n - - c - - . . . n c - - - n - c . . . . . n - - - c - - n - c - n - c - -
        . . . n c - - n n - . . - - - c - - . . n n . . . c - - . n n . - - c . c c - - . . . . - - n c c . . . . . . n - c c n - c - . . . n - c - . n - c - n - c . . . . n c n - -
        c c . c n . . . n c c . - - . n c . n c c . c . . n - . - . n n - c n - . c . . n c n . - c c n n n - c n - c n - c . . . . . n . n n c c - - n c . . . . . . . n . c c c - -
        . . . c c n c . . . n c n c - c n - c n c c . n . n c n . n . . - n n c c . n c c c c - n . . . . n c . n - . c - n . n . n . . c c c c n . - c c n . n - n n - c n . c c . .
        c . n . . c c c c n c c . . . . . . n n . n n . n . . c - . . c . . . n . n . . c n c n . n c . . c n n n c n c n n c c - . - c c n . c c n - . n c n n . . n c n n c . n - c
        c c c c c c n . . . . . c n c n n - . . . . c c c c n n c . . . - . n n n n c n . . . n c c . n n . c n . . n n . n n c n n - c c c c . . n c c . n c . n n c c . c n n . - n
        . n c . . . . c . . . n . . n . . c c c . . . c n . . . n c n n . n . . c . n n c c n c c n n c n c . c c n n . c . c . c c n c n . c n n c c . . . n c c n c n n n c n n c n
      TABLE
    end
  end
end
