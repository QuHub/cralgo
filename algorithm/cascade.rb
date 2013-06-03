module Algorithm
  class Cascade
    attr_accessor :input, :output
    def initialize(input, output)
      raise "Input and Output size mismatch" unless input.length == output.length
      self.input = input
      self.output = output
    end

    def circuit
      stretch
    end

    def stretch
      [].tap do |gates|
        gate = []
        input.each do |bit|
          p bit
          gate << bit
          if bit =~ /c|n/
            if !(gate & %w(c n)).empty?
              gate << '+'
              gates << gate
              gate = ['.'] * (gate.length -1)
              gate << 'c'
            end
          end
        end
      end
    end

    def combine
      input.map.with_index do |_, index|
        render_to_gates input[index] + output[index]
      end
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
  end
end
