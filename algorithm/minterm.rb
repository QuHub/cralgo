module Algorithm
  class Minterm
    attr_accessor :input, :output, :gates, :added_qubit_index
    def initialize(input, output, gates=nil)
      self.input = input
      self.output = output
      self.gates = gates || Grid.new(0, input.length, '.')
      self.added_qubit_index = []
    end

    def cascade
      stretch
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
            added_qubit_index << index
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
  end
end
