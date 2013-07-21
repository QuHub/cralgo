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

  def self.create(pair, index)
    pair.zip(EncodingMap[pair]).map do |value, encoding|
      new(:value => value, :encoding =>  encoding, :index => index)
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
      @encoded_inputs ||= function.inputs.each_with_index.map do |term, index|
        term.each_slice(2).map do |pair|
          Digit.create(pair, index)
        end
        .flatten
      end
    end


    def group_and_sort_inputs(inputs, bit_index)
      groups = Hash[inputs.group_by {|term| term[bit_index].encoding}.sort]

      sorted_list ||= []
      groups.each do |key, group|
        if group.size > 1
          sorted_list << group_and_sort_inputs(group, bit_index + 2).flatten(1)
        else
          sorted_list << group
        end
      end
      sorted_list
    end

    def sorted_inputs
      group_and_sort_inputs(encoded_inputs, 0).flatten(1)
    end

    def activation_table
      term_history = []   # history from top

      sorted_inputs.transpose.each do |variable|
        b = 10
        variable_history = nil # history from left
        variable.each_with_index do |term_bit, index|
          term_bit.activation = '.'
          term_bit.b = b

          if term_bit.value == -1
            term_bit.activation = '.'
            next
          end

          if term_bit.encoding != 10
            if term_bit.encoding != b || term_history[index]
              b = term_bit.encoding
              term_bit.activation = term_bit.value  == 1 ? 'c' : 'n'

              if term_bit.activation == variable_history && !term_history[index]
                term_bit.activation = '-'
              end
              variable_history = term_bit.activation if %(c n).include?(term_bit.activation)
            else
              term_bit.activation = '-'
            end
          end

          term_history[index] =  %w(c n).include?(term_bit.activation) unless term_history[index]
        end
      end.transpose
    end

    def sorted_outputs
      new_input_order = activation_table.map(&:first).flatten.map(&:index)
      new_input_order.map do |index|
        function.outputs[index]
      end
    end

    def map
      hash = {
        'ncnn' => ['n...'],
        'nccc' => ['.c..'],
        'nncc' => ['....', 'n...', '.n..', '....'],
        'ccnn' => ['....', 'n...', '.n..', '....'],
        'nccn' => ['c...', '.c..'],
        'cnnc' => ['c...', '.c..'],
      }

      hash.dup.each do |k,v|
        (0..k.length-1).each do |index|
          n = k.dup
          n[index] = '-'
          if !hash[n] || hash[n].length > v.length
            hash[n] = v
          end
        end
      end
      hash
    end

    def reduce_inputs(mt1, mt2)
      pp map
      (0..mt1.length-2).each do |index|
        key = (mt1[index,2] + mt2[index,2]).flatten.map(&:activation).join
      end
    end

    #def reduced_control_lines
      #(0..sorted_outputs.length-2).each do |index|
        #next unless sorted_outputs[index] == sorted_outputs[index+1]
        #reduce_inputs(*sorted_inputs[index, 2])
      #end
    #end

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
