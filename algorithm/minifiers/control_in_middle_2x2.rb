module Minifiers
  class ControlInMiddle2x2 < Base
    attr_accessor :grid, :mark, :modified

    private
    def process
      (0..mark.length-4).each do |index|
        m0 = mark[index]
        m1 = mark[index+1]
        m2 = mark[index+2]
        m3 = mark[index+3]

        if(m0.last == m2.last && m1.last == m3.last)
          col = grid.col(index)
          col[ m0.last[2] ] = '.'
          m1.last[1..-1].each {|i| col[i] = '+' }
          grid.replace_col(index, col)

          col = grid.col(index+2)
          col[ m2.last[2] ] = '.'
          m1.last[1..-1].each {|i| col[i] = '+' }
          grid.replace_col(index+2, col)

          # delete them from the righthand side first
          grid.delete_col(index+3)
          grid.delete_col(index+1)

          self.modified = true
          return
        end
      end
    end
  end
end
