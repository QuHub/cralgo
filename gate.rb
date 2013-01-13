class Gate 
  def initialize
    @cnot = {}
    @cv = {}
  end

  def nn_cost(gate)
    n_vars = gate[0][1..-1].to_i
    cost(n_vars)
  end

  def original_cnot_gates(n)
    2**(n-1) - 2
  end

  def cnots_from_distant_cv_swap(n)
    2*2*(n-2) 
  end

  def cnots_from_middle_distant_cnots(n)
    cnots = stage = 2
    (3..n-2).map do |k| 
      stage = 2 * stage + 2*(k-1)
      cnots += stage
    end
    2 * cnots
  end

  def cnots_from_reflection_gates(n)
    2* (2..n-2).inject(0) {|r,k| k**2 - 1}
  end

  def number_of_cnot_gates(n)
    @cnot[n] ||=  original_cnot_gates(n) + cnots_from_distant_cv_swap(n) + 
                  cnots_from_middle_distant_cnots(n) + cnots_from_reflection_gates(n)
  end

  def number_of_cv_gates(n)
    @cv[n] ||= 2**(n-1) - 1
  end

  def cost(n)
    number_of_cv_gates(n) + number_of_cnot_gates(n)
  end
end
