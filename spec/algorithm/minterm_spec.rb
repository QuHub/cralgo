require 'spec_helper'

describe Algorithm::Minterm do
  describe '#cascade' do
		shared_examples_for "a cascade" do |input, output, *cascade|
			it "expand activation minterm to Toffoli gates" do
				klass = described_class.new(input.split(''), output.split(''))
				klass.cascade.inspect.should == vertical(cascade)
			end
		end

		it_should_behave_like "a cascade", 'c..', '100', 'c..+..'
		it_should_behave_like "a cascade", 'cc.', '100', 'cc.+..'
		it_should_behave_like "a cascade", 'cn.', '100', 'cn.+..'
		it_should_behave_like "a cascade", 'nc.', '100', 'nc.+..'

		it_should_behave_like "a cascade", 'c.c.', '100', 'c.c.+..'
		it_should_behave_like "a cascade", 'c.n.', '100', 'c.n.+..'
		it_should_behave_like "a cascade", 'c..c', '100', 'c..c+..'
		it_should_behave_like "a cascade", 'cc.ccccc.', '100',
      'cc.+.............',
      '...cc+...........',
      '.....cc+.........',
      '.......cc+.......',
      '.........cc+.....',
      '...........cc.+..'
  end

	describe '#stretch', :dev => true do
		shared_examples_for "stretched" do |input, *cascade|
			subject{described_class.new(input.split(''), nil)}
			it "stretches the gate into as many Toffoli gates as needed" do
				subject.stretch.inspect.should == vertical(cascade)
			end
		end

		# The number of Toffoli gates is #of controls - 1 , for controls > 1
		it_should_behave_like "stretched", 'c..', 'c..'
  	it_should_behave_like "stretched", 'cc.', 'cc.'
  	it_should_behave_like "stretched", 'cn.', 'cn.'
  	it_should_behave_like "stretched", 'nc.', 'nc.'
		it_should_behave_like "stretched", 'ccc.', 'cc+..', '..cc.'
		it_should_behave_like "stretched", 'cnc.', 'cn+..', '..cc.'
		it_should_behave_like "stretched", 'cnn.', 'cn+..', '..cn.'
		it_should_behave_like "stretched", 'cc.c.',
      'cc.+..',
      '...cc.'
		it_should_behave_like "stretched", 'cn.c.',
      'cn.+..',
      '...cc.'
		it_should_behave_like "stretched", 'cn.n.',
      'cn.+..',
      '...cn.'
		it_should_behave_like "stretched", 'cc.cc.',
      'cc.+....',
      '...cc+..',
      '.....cc.'
		it_should_behave_like "stretched", 'cc.ccccc.',
      'cc.+..........',
      '...cc+........',
      '.....cc+......',
      '.......cc+....',
      '.........cc+..',
      '...........cc.'
	end
end