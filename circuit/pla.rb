module Circuit
  class Pla
    attr_accessor :source, :number_inputs, :number_outputs, :function, :inputs, :outputs, :expand_inputs
    Encode = lambda {|x| x == '-' ? -1 : x.to_i }

    def initialize(source, opts = {:expand_inputs => true})
      self.expand_inputs = opts[:expand_inputs]
      self.inputs = []
      self.outputs = []
      File.open(source).each do |line|
        case(line.strip)
          when /Function: (.*)/ then self.function = $1
          when /\.i\s+(.*)/    then self.number_inputs = $1.to_i
          when /\.o\s+(.*)/    then self.number_outputs = $1.to_i
          when /^([\d\-]+)\s+([\d\-]+)$/  then
            input, output = $1, $2
            expanded_input = expand(input)
            self.inputs +=  expanded_input
            self.outputs += [output.split('').map(&Encode)] * expanded_input.size
        end
      end
    end

    def expand(term)
      if expand_inputs
        expanded = Algorithm::Expander.new(term).expanded
        expanded.map {|x| x.split('').map(&Encode) }
      else
        term.split('').map(&Encode)
      end
    end

		def inspect
			inputs.zip(outputs).each do |input, output|
				puts "%s %s" % [input.join, output.join]
			end
			nil
		end
  end
end
