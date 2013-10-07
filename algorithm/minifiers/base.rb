module Minifiers
  class Base
    attr_accessor :grid, :output_size
    def initialize(grid, output_size)
      self.grid = Algorithm::Grid.from_matrix(grid)
      self.output_size = output_size
    end
  end
end
