require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe '4gt11' do
  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/4gt11.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      algorithm.activation_table.map(&activation).should == decode(<<-TABLE)
        c - - -
        c - - -
        n - c -
        n c n c
      TABLE
    end
  end
end
