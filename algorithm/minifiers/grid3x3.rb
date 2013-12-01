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
      @replacements ||= begin
        negative_control = {
          # skipping ancilla bit (c)
          'nncncnnccccn' => %w(...+... .c.+... ...+... ...c+n. n...c.+),
          'nncncnnccncn' => %w(...n+n. n...c.+),
          'nncncnnccncc' => %w(.c...+. ...n+c. .c...+. n...c.+),
          'nncccnnccccc' => %w(.....+. .c...+. .....+. ...c+c. n...c.+),
          'nncccnnccncn' => %w(.c.+... ...c+n. .c.+... n...c.+),
          'nncccnnccccn' => %w(...c+n. n...c.+),
          'nnccccnccncc' => %w(.c.+... ...c+c. .c.+... n...c.+),
          'nnccccnccccc' => %w(...c+c. n...c.+),
          'nnccccnccccn' => %w(.c...+. ...c+c. .c...+. n...c.+),
          'nncnccnccccc' => %w(...+... .c.+... ...+... ...c+c. n...c.+),
          'nncnccnccncn' => %w(.c...+. ...n+c. .c...+. n...c.+),
        }

        positive_control = {}.tap do |hash|
          negative_control.each do |k,v|
            key = k.dup
            key[0] = key[6] = 'c'
            value = Marshal.load(Marshal.dump(v))
            value.last[0] = 'c'
            hash[key] = value
          end
        end

        negative_control.merge(positive_control)
      end
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







