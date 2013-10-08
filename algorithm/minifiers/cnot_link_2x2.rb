module Minifiers
  class CnotLink2x2 < Base
    attr_accessor :grid, :mark, :modified

    private
    def process
      (0..mark.length-2).each do |index|
        m0 = mark[index]
        m1 = mark[index+1]

        if(m0.last[2] == m1.last[0] && m1.last.length == 2)
          col = grid.col(index)
          col[ m0.last[2] ] = '.'
          m1.last[1..-1].each {|i| col[i] = '+' }
          grid.replace_col(index, col)

          grid.delete_col(index+1)

          self.modified = true
          return
        end
      end
    end
  end
end
