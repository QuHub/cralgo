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
      col = input.join
#      col.sub!(/\-(.*)\.(.*)[c|n]/) {|x| x.tr('.', '-')}
      col.sub!(/(\-)(c|n)/, 'c\2')
      col.split('')
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
      #  puts @gates.inspect

        input = grid.col(index)
        output = outputs[index]
        minterm = Minterm.new(with_top_control_line(input), output, grid, @gates)
        puts minterm.gates.inspect
        @gates = minterm.stretch
        gate_output_column_index[index] = @gates.width

        # update the input grid with the new qubits inserted as part of previous
        # expansion steps.
        minterm.added_qubit_index.each do |i|
          duplicate = grid.row(i).dup.map {|x| x.tr('cn', '*') }
          grid.insert_row(i, duplicate)
        end
      end
      correct_dont_cares
      combine_with_outputs
      @gates
    end

    def correct_dont_cares
      (0..@gates.height-1).each do |index|
        row = @gates.row(index).join
        row.sub!(/[n|c](.*)\-(.*)/) {|x| x.tr('.', '-')}
        @gates.replace_row(index, row.split(''))
      end

      #(0..@gates.width-1).each do |index|
        #col = @gates.col(index).join
        #col.sub!(/^((.)(\-|\.)+)[n|c]/) {|x| x.tr('.', '-')}
        #@gates.replace_col(index, col.split(''))
      #end
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


__END__
Insert ancilla row before, and column after
Insert + and c
Move bits after i to new col
Clear bits after i in current col
Move 'C' from previous row to new ancilla row






