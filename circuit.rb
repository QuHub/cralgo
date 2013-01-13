class Circuit
  attr_accessor :source, :variables, :num_vars, :library, :function, :gates, :cost
  def initialize(source)
    @dist = nil
    @gate = Gate.new
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

