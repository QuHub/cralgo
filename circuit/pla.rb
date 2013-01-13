module Circuit
  class Pla
    attr_accessor :source, :number_inputs, :number_outputs, :function, :inputs, :outputs
    Encode = lambda {|x| x == '-' ? -1 : x.to_i }

    def initialize(source)
      @dist = nil
      @gate = Gate.new
      File.open(source).each do |line|
        case(line)
          when /Function: (.*)/ then self.function = $1
          when /\.i\s+(.*)/    then self.number_inputs = $1.to_i
          when /\.o\s+(.*)/    then self.number_outputs = $1.to_i
          when /^([\d\-]+)\s+([\d\-]+)$/  then
            input, output = $1, $2
            (self.inputs ||= []) << input.split('').map(&Encode)
            (self.outputs ||= []) << output.split('').map(&Encode)
        end
      end
    end
  end
end
