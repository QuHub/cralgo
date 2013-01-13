module Algorithm
  class Base
    attr_accessor :function

    EncodingMap = {
      [0,0] =>  [2, 2],
      [0,1] =>  [3, 3],
      [1,0] =>  [4, 4],
      [1,1] =>  [5, 5],
      [0,-1] => [6, 6],
      [1,-1] => [7, 7],
      [-1,0] => [8, 8],
      [-1,1] => [9, 9],
      [-1,2] => [10,10]
    }

    def initialize(function)
      p 'heelllo'
      self.function = function
    end

    def encode
      function.inputs.each_slice(2).map do |pair|
        EncodingMap[pair]
      end
    end
  end
end
