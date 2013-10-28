module Algorithm
  class Expander
    def initialize(term)
      @term = term
      @result = []
    end

    def expanded(term = @term)
      if (index = term =~ /-/)
        zero, one = term.dup, term.dup
        zero[index] = '0'
        one[index] = '1'
        expanded(zero)
        expanded(one)
        @result
      else
        @result << term
      end
    end
  end
end
