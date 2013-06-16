module Algorithm
  class Minterm
    attr_accessor :input, :output, :gates
    def initialize(input, output, gates=nil)
      self.input = input
      self.output = output
      self.gates = gates || Grid.new(0, input.length, '.')
    end

    def cascade
      stretch
      combine_with_output
    end

    # itr:     input(n) , input(n+1)
    # 1:    '..c.ccc....', '..c.c+'
    # 2:         'Ccc....','.....cc+'
    # 3:          'Cc....','.......cc....'

    def stretch(minterm=input)
      count = 0

      if minterm.count {|e| e =~ /c|n/ } <= 2
        gates.insert_col(-1, minterm)
        return gates
      end

      gate= Array.new(gates.height, '.')
      minterm.each.with_index do |bit, index|
        if bit =~ /c|n/
          if count >= 2 && !(gate & %w(c n)).empty?
            gate.insert(index, '+')

            # insert a new anciallary qubit
            #   ccc.
            # 1 cc+..
            # 2 ..cc.
            gates.insert_row(index)
            gates.insert_col(-1, gate)

            remaining = ['.'] * index + ['c'] +  minterm[index..-1]

            stretch(remaining)

            return gates
          else
            count += 1
            gate[index] = bit
          end
        end
      end
      gates
    end

    def combine_with_output
      offset = gates.height
      output.length.times do |_|
        gates.insert_row(-1)
      end

      output.each.with_index do |bit, index|
        gates.grid[offset+index][-1] = map[bit]
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
