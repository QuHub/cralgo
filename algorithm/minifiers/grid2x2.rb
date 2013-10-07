module Minifiers
  class Grid2x2
    attr_accessor :grid, :mark, :modified
    def initialize(grid)
      self.grid = grid
    end

    def build_markers
      self.mark = []
      grid.width.times do |index|
        token = ''
        location = []
        grid.col(index).each.with_index do |c,i|
          if c != '.'
            token <<  c
            location << i
          end
        end
        self.mark << [token.tr('+', ''), location]
      end
      self.mark
    end

    def replacements
      {
        cc: { cc: [                       ] , cn: ['c.'       ] , nc: ['.c'       ] , nn: ['..', 'n.', '.n', '..' ] },
        cn: { cc: ['c.'                   ] , cn: [           ] , nc: ['c.', '.c' ] , nn: ['.n'                   ] },
        nc: { cc: ['.c'                   ] , cn: ['c.', '.c' ] , nc: [           ] , nn: ['n.'                   ] },
        nn: { cc: ['..', 'n.', '.n', '..' ] , cn: ['.n'       ] , nc: ['n.'       ] , nn: [                       ] },
      }
    end

    def reduce
      begin
        build_markers
        self.modified = false
        process
      end while modified
    end

    def process
      (0..mark.length-2).each do |index|
        m1 = mark[index]
        m2 = mark[index+1]

        if(m1.last== m2.last)
          replacement_minterms = replacements[m1.first.to_sym][m2.first.to_sym]
          grid.delete_col(index)
          grid.delete_col(index)

          replacement_minterms.reverse.each do |replacement|
            grid.insert_col(index, replacement_column(m1.last, replacement))
          end
          self.modified = true
          return
        end
      end
    end

    def replacement_column(positions, replacement)
      col = ['.'] * grid.height
      col[positions[0]] = replacement[0]
      col[positions[1]] = replacement[1]

      # set output bits to be the same as the original terms
      positions[2..-1].each { |i| col[i] = '+'}
      col
    end
  end
end
