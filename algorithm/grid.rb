module Algorithm
  class Grid
    attr_accessor :grid, :initializer, :width, :height
    def initialize(width, height, initializer)
      self.grid = height.times.map do |_|
        Array.new(width, initializer)
      end
      self.initializer = initializer
      self.width = width
      self.height = height
    end

    def insert_row(at, initializer=nil)
      initializer ||= @initializer
      initializer = case initializer
      when String then width.times.map{initializer.dup}
      when Array then
        raise ArgumentError if initializer.length != @width
        initializer
      end

      @grid.insert(at, initializer)
      @height +=  1
      self
    end

    def insert_col(at, initializer=nil)
      initializer ||= @initializer
      initializer = case initializer
      when String then height.times.map{initializer.dup}
      when Array then
        raise ArgumentError if initializer.length != @height
        initializer
      end

      @grid.each.with_index do |row, index|
        row.insert(at, initializer[index])
      end
      @width += 1
      self
    end

    def row(index)
      @grid[index]
    end

    def replace_row(index, row)
      @grid[index] = row
    end

    def replace_col(index, col)
      height.times.each do |i|
        @grid[i][index] = col[i]
      end
    end

    def col(index)
      [].tap do |col|
        height.times.each do |i|
          col << @grid[i][index]
        end
      end
    end

    def initializer=(value)
      @initializer = value
    end

    def inspect
      grid.map {|x| x.join(' ')}.join("\n")
    end
  end
end
