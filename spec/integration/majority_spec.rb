require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe 'majority' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/majority.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        c - - . .
        c - . - .
        c . - - .
        . . . . c
        . c - - .
      TABLE
    end
  end
end
