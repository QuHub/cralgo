module Minifiers
  class Base
    attr_accessor :grid, :output_size, :reduced
    def initialize(grid, output_size)
      self.grid = grid
			if grid.is_a? String
      	self.grid = Algorithm::Grid.from_matrix(grid)
			end
      self.output_size = output_size
			self.reduced = false
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

    def reduce
      begin
        build_markers
        self.modified = false
        process
				self.reduced = true if modified
      end while modified
			grid
    end
  end
end
