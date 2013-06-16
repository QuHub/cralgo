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
      @grid.insert(at, Array.new(width, initializer))
      @height +=  1
      self
    end

    def insert_col(at, initializer=nil)
      initializer ||= @initializer
      initializer = case initializer
      when String then [initializer] * height
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

    def initializer=(value)
      @initializer = value
    end

    def inspect
      grid.map {|x| x.join(' ')}.join("\n")
    end
  end
end
