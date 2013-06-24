module Algorithm
  class Cascade
    attr_accessor :inputs, :outputs, :gates, :gate_output_column_index
    def initialize(inputs, outputs)
      raise "Input and Output size mismatch" unless inputs.length == outputs.length
      self.inputs = inputs
      self.outputs = outputs
      self.gate_output_column_index = {}
    end

    def with_top_control_line(input)
      first_control = (input.join =~ /c|n/i)
      input[first_control - 1].tr!('-.', 'c') if first_control > 0
      input
    end

    def grid
      @grid ||= begin
        grid = Grid.new(0, inputs[0].length, '.')
        inputs.each do |input|
          grid.insert_col(-1, input)
        end
        grid
      end
    end

    def render
      @gates = nil
      inputs.each.with_index do |_, index|
        input = grid.col(index)
        output = outputs[index]
        minterm = Minterm.new(with_top_control_line(input), output, @gates)
        @gates = minterm.stretch
        gate_output_column_index[index] = @gates.width

        # update the input grid with the new qubits inserted as part of previous
        # expansion steps.
        minterm.added_qubit_index.each do |i|
          grid.insert_row(i)
        end
      end
      combine_with_outputs
    end

    def combine_with_outputs
      offset = @gates.height
      outputs[0].length.times do |_|
        @gates.insert_row(-1, '.')
      end

      outputs.each.with_index do |output, x|
        output.each.with_index do |bit, y|
          @gates.grid[offset+y][gate_output_column_index[x] - 1] = map[bit]
        end
      end
      gates
    end

    def map
      @map = {
        '1' => '+', '0' => '.',
        'c' => 'c', 'n' => 'n',
        '-' => '-', '.' => '.'
      }
    end
  end
end
