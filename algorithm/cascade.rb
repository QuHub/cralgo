module Algorithm
  class Cascade
    attr_accessor :inputs, :outputs, :gates, :gate_output_column_index
    def initialize(inputs, outputs)
      raise "Input and Output size mismatch" unless inputs.length == outputs.length
      self.inputs = inputs
      self.outputs = outputs
    end

    def grid
      @grid ||= begin
        grid = Grid.new(0, combined[0].length, '.')
        combined.each do |input|
          grid.insert_col(-1, input)
        end
        grid
      end
    end

    def combined
      @combined ||= begin
        inputs.map.with_index do |input, index|
          input = input.join('').sub('-c','Cc').sub('-n','Cn').split('')
          input + outputs[index]
        end
      end
    end

    #  Algorithm:
    #   When the third c|n is detected at (y,x)
    #    Insert ancilla row at (x), and column at (y+1)
    #    Insert + at (y,x), and c at (y,x+1)
    #    Move bits after i to new col
    #    Clear bits after i in current col
    #    Move 'C' from previous row to new ancilla row
    def render
      x = 0
      while(x < grid.width) do
        minterm = grid.col(x)
        x += 1
        next if minterm.count {|e| e =~ /c|n/i  } <= 2
        process_column(x-1)
      end

      #puts grid.inspect
      # now move the 'C' down to the added ancilla bit
      (0..grid.width-1).each do |x|
        minterm = grid.col(x).join('')
        minterm = minterm.sub('C.', '.c').tr('01-','.+.').downcase.split('')
        grid.replace_col(x,minterm)
      end
      grid
    end

    def process_column(x)
      count = 0
      minterm = grid.col(x)

      minterm.each.with_index do |bit, y|
        if bit =~ /c|n/i
          if count >= 2
            grid.insert_row(y)
            grid.row(y)[x] = '+'
            grid.insert_col(x+1)
            grid.row(y)[x+1] = 'c'

            # copy the remaining bits to the newly added gate
            (y+1..grid.height-1).each do |i|
              grid.row(i)[x+1] = grid.row(i)[x]
              grid.row(i)[x] = '.'
            end
            return
          else
            count += 1
          end
        end
      end
    end
  end
end







