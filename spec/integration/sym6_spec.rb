require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe 'Sym6' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/sym6.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        n - - - - - - - - - - - - - - - - - - - - - - - - c - - - - - - - - - - - - - - - - - - - - - - - -
        n - - - - - - - - - - c - - - - - - - - - - - - - n - - - - - - - - - - - - - c - - - - - - - - - -
        n - - - c - - - - - - n - - - - - - c - - - - - - n - - - - - - c - - - - - - n - - - - - - c - - -
        n c - - n - - c - - - n - - c - - - n - - - c - - n - - c - - - n - - - c - - n - - - c - - n - - c
        c n c - n c - n - c - n c - n - c - n - c - n - c n c - n - c - n - c - n - c n - c - n - c n - c n
        c c n c c n c n c n c c n c n c n c n c n c n c n c n c n c n c n c n c n c n n c n c n c n n c n n
      TABLE
    end
  end
end
