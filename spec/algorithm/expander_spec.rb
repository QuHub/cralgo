require 'spec_helper'

describe Algorithm::Expander do
  shared_examples :expander do |term, result|
    subject {described_class.new(term)}
    it "expands don't cares to 0/1 each: '#{term}'" do
      subject.expanded.should =~ result
    end
  end

  it_should_behave_like :expander, '0110-', ['01100', '01101']
  it_should_behave_like :expander, '0110-10', ['0110010', '0110110']
  it_should_behave_like :expander, '-011010', ['0011010', '1011010']
  it_should_behave_like :expander, '-0110-', %w(001100 001101 101100 101101)
  it_should_behave_like :expander, '-01-0-', %w(001000 001001 101000 101001 001100 001101 101100 101101)
end

