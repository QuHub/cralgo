FN=%w(alu1 alu2 alu3 alu4 5xp1 9sym apex2 apex4 apex5 bw rd53 rd73 Modulo\ 10\ Counter)
require 'rubygems'
require 'ruby-debug'

Bundler.require(:default) if defined?(Bundler)

class Fixnum
  def commify
    self.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end
end

class MCTGate 
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

gate = MCTGate.new

(3..9).each do |n|
  p [n, gate.cost(n)]
end


class Circuit
  attr_accessor :source, :variables, :num_vars, :library, :function, :gates, :cost
  def initialize(source)
    @dist = nil
    @mct_gate = MCTGate.new
    File.open(source).each do |line|
      case(line)
        when /Used Library: (\w*) \(Gates: (\d*),.*costs: (\d*)\)/ then
          @library = $1
          @num_gates = $2
          @cost = $3
          return if @library != 'MCT'
        when /Function: (.*)/ then @function = $1
        when /numvars (\d*)/ then  @num_vars = $1
        when /variables (.*)/ then @variables = $1.split(' ')
        when /inputs (.*)/ then 
          @inputs = $1.split(' ').reject!{|x| x =~ /^(0|1)$/ }
        when /^t(\d*)/ then
          (@gates ||= []).push line.strip.split(' ')
      end
    end
  end

  def qubit_distance(q)
    q1 = @variables.index( q[0] )
    q2 = @variables.index( q[1] )
    (q2 - q1).abs - 1
  end

  def gate_distance(gate)
    count = gate[0][1..-1].to_i - 1
    (1..count).inject(0) do |r,e| 
      r + qubit_distance(gate[e..e+1])
    end
  end

  def num_swap_gates
    return @dist if @dist
    @dist = 0
    @gates.each_with_index do |gate, index|
      @dist += case(gate[0][0])
        when 't' then 
          gate_distance(gate)
        else
          raise "We don't know you: index (%d) %s" % [index, gate]
      end
    end
    @dist *= 2 # for mirrors
  end

  def circuit_swap_cost
    num_swap_gates * 2 
  end

  def mct_swap_cost
    @gates.inject(0) {|r, gate| r + @mct_gate.nn_cost(gate)}
  end

  def total_cost
    circuit_swap_cost + mct_swap_cost
  end

  def ratio
    @num_vars.to_f / @inputs.size.to_f
  end
end



Dir.glob('revlib/*').each do |file|
  circuit = Circuit.new (file)
  if !circuit.nil? && circuit.library == 'MCT'
#debugger if circuit.function == 'rd32'
    puts [circuit.function, circuit.num_vars,circuit.cost, circuit.ratio, circuit.circuit_swap_cost, circuit.mct_swap_cost, circuit.total_cost] * ", "
  end
end 
exit


