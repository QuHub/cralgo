module Algorithm
  class Minterm
    attr_accessor :input, :output, :gates
    def initialize(input, output)
      self.input = input
      self.output = output
      self.gates = []
    end

    def cascade
      stretch(input)
      combine
      pad
    end

    # itr:     input(n) , input(n+1)
    # 1:    '..c.ccc....', '..c.c+'
    # 2:         'Ccc....','.....cc+'
    # 3:          'Cc....','.......cc....'

    def stretch(input, prefix=[])
      gate = []
      count = 0
      if input.count {|e| e =~ /c|n/ } <= 2
        gates << prefix + input
        return gates
      end

      input.each.with_index do |bit, index|
        gate << bit and next unless bit =~ /c|n/

        if count >= 2 && !(gate & %w(c n)).empty?
          remaining = input[index..-1]
          remaining.unshift('c')
          gate << '+'
          gates << prefix + gate
          stretch(remaining, prefix + ['.'] * (gate.size - 1))

          # pad gates at the end with '.'
          longest = gates.last.length
          gates.each.with_index do |gate, index|
            missing = longest - gate.length
            gates[index] = gate + (['.'] * missing)
          end
          return gates
        else
          count += 1
          gate.push(bit)
        end
      end
      gates << prefix + gate
    end

    def combine
      nop_output = ['.'] * output.length
      gates[0..-1].map do |gate|
        gate += nop_output
      end

      gates[-1] +=  render_to_gates(output)
      gates
    end

    def map
      @map = {
        '1' => '+', '0' => '.',
        'c' => 'c', 'n' => 'n',
        '-' => '-', '.' => '.'
      }
    end

    def render_to_gates(minterm)
      minterm.map do |bit|
        map[bit]
      end
    end

    def pad
      width = gates.map(&:length).max
      gates.map do |gate|
        gate += ['.'] * (width - gate.length)
      end
    end
  end
end
