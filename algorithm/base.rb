require 'ostruct'
class Digit < OpenStruct
  EncodingMap = {
    [0,0]   => [2, 2],
    [0,1]   => [3, 3],
    [1,0]   => [4, 4],
    [1,1]   => [5, 5],
    [0,-1]  => [6, 6],
    [1,-1]  => [7, 7],
    [-1,0]  => [8, 8],
    [-1,1]  => [9, 9],
    [-1,-1] => [10,10],
    [0]     => [0],
    [1]     => [1],
    [-1]    => [-1],
  }

  def self.create(pair)
    pair.zip(EncodingMap[pair]).map do |value, encoding|
      new(:value => value, :encoding =>  encoding)
    end
  end
end

module Algorithm
  class Base
    attr_accessor :function

    def initialize(function)
      self.function = function
    end

    def encoded_inputs
      function.inputs.map do |term|
        term.each_slice(2).map do |pair|
          Digit.create(pair)
        end
        .flatten
        .each_with_index {|d, i| d.index = i}
      end
    end

    def indexed_inputs
      encoded_inputs.each do |term|
        
      end
    end

    def dump(list)
      list * ' '
    end

    def inspect
      (0..encoded_inputs.length-1).map do |index|
        p encoded_inputs[index]
        "%s | %s\n" % [dump(encoded_inputs[index]), dump(function.outputs[index])]
      end
    end
  end
end
