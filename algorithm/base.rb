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
      @encoded_inputs ||= function.inputs.map do |term|
        term.each_slice(2).map do |pair|
          Digit.create(pair)
        end
        .flatten
        .each_with_index {|d, i| d.index = i}
      end
    end
    

    def group_and_sort(inputs, bit_index)
      groups = Hash[inputs.group_by {|term| term[bit_index].encoding}.sort]
      
      sorted_list ||= []
      groups.each do |key, group|
        if group.size > 1
          sorted_list << group_and_sort(group, bit_index + 2).flatten(1)
        else
          sorted_list << group
        end
      end
      sorted_list
    end

    def sorted_inputs
      group_and_sort(encoded_inputs, 0).flatten(1)
    end

    def activation_table
      sorted_inputs.transpose.each do |variable|
        b = 10
        variable.each do |term_bit|
          term_bit.activation = '.'
          term_bit.b = b
          if term_bit.value == -1
            term_bit.activation = '.'
            next
          end
          if term_bit.encoding != 10
            if term_bit.encoding != b
              b = term_bit.encoding
              term_bit.activation = term_bit.value  == 1 ? 'c' : 'n'
            else
                term_bit.activation = '-'
            end
          end
        end
      end.transpose
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
