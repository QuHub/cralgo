module Minifiers
  class Grid3x3 < Base
    attr_accessor :grid, :mark, :modified, :output_size
    private
    def process
      (0..mark.length-4).each do |index|
        # positions for 4 markers
        m = [].tap {|a| 4.times.map {|i| a << mark[i] } }

        if(m[0].last == m[2].last && m[1].last == m[3].last)
          key = m.map(&:first).join
          replacement_minterms = replacements[key]
          raise "Undefined minterm sequence: #{key}" if replacement_minterms.nil?
          4.times.each {grid.delete_col(index)}

          replacement_minterms.reverse.each do |replacement|
            positions = m[0].last[0..1] + m[1].last[1..2]
            grid.insert_col(index, replacement_column(positions, replacement))
          end
          self.modified = true
          return
        end
      end
    end

    def replacements
      {
        # skipping ancilla bit (c)
        'nncncccn' => %w(.+.. c+.. .+.. .cn+ .+.. c+.. .+..),
        'nncncncn' => %w(.nn+),
        'nncncncc' => %w(c.+. .nc+ c.+.),
        'nccncccc' => %w(..+. c.+. ..+. .cc+ ..+. c.+. ..+.),
        'nccncncn' => %w(c+.. .cn+ c+..),
        'nccncccn' => %w(.cn+),
        'nccccncc' => %w(c+.. .cc+ c+..),
        'nccccncc' => %w(.cc+),
        'nccccccn' => %w(c.+. .cc+ c.+.),
        'nncccccc' => %w(.+.. c+.. .+.. .cc+ .+.. c+.. .+..),
        'nncccncn' => %w(c.+. .nc+ c.+.),
      }
    end

    def replacement_column(positions, replacement)
      col = ['.'] * grid.height
      4.times.each {|i| col[positions[i]] = replacement[i] }
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







