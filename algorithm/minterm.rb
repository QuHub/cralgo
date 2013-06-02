module Algorithm
  class Minterm
    attr_accessor :input, :output, :gates
    def initialize(input, output)
      self.input = input
      self.output = output
      self.gates = []
    end

    def cascade
      stretch
      combine
      pad
    end

    def stretch
      gate = []
      input.each do |bit|
        if bit =~ /c|n/
          if !(gate & %w(c n)).empty?
            gate += [bit, '+']
            gates << gate
            gate = ['.'] * (gate.size - 1)
            gate << 'c'
          else
            gate << bit
          end
        else
          gate << bit
        end
      end
      gates << gate
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
