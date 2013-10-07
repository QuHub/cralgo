require 'spec_helper'

def activation
  lambda {|arr| arr.map(&:activation)}
end

describe 'parity', :pending => true do

  describe 'read pla file' do
    let(:function) {Circuit::Pla.new('./spec/fixtures/parity.pla')}
    let(:algorithm) {Algorithm::Base.new(function)}

    it 'creates activation table' do
      p function
      algorithm.activation_table.map(&activation).transpose.map(&joinit).should == decode(<<-TABLE)
      TABLE
    end
  end
end
