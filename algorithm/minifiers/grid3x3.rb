module Minifiers
  class Grid3x3 < Base
    attr_accessor :grid, :mark, :modified, :output_size
    private
    def process
      (0..mark.length-6).each do |index|
        # positions for 6 markers
        m = [].tap {|a| 6.times.map {|i| a << mark[index+i] } }

        if match?(m)
          key= m.map(&:first).join
          replacement_minterms = replacements[key]
          raise "Undefined minterm sequence: #{key}" if replacement_minterms.nil?
          6.times {grid.delete_col(index) }

          replacement_minterms.reverse.each do |replacement|
            positions = m[0].last[0..2] + m[1].last[1..2] + m[2].last[1..2]
            grid.insert_col(index, replacement_column(positions, replacement))
          end
          self.modified = true
          return
        end
      end
    end

    def match?(m)
      pos= m.map(&:last)
      3.times.all? {|i| pos[i] == pos[3+i]} &&
      (pos[0][2] == pos[1][0] && pos[1][2] == pos[2][0])
    end

    def replacements
      {
        # skipping ancilla bit (c)
        'nncncnnccccn' => %w(...+... .c.+... ...+... ...c+n. n...c.+),
      }
    end

    def replacement_column(positions, replacement)
      col = ['.'] * grid.height
      7.times.each {|i| col[positions[i]] = replacement[i] }
      col
    end
  end
end

__END__

Decomposition
n     n
n =   n
.     + c
n       n
+       +

a  n    c        . c . .
b  n    c        + + + c
c  + c  + c  =   . . . .
d    n    n      . . . n
e    +    +      . . . +







