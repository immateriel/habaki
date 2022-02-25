module Habaki
  class Value < Node
    # @return [String, Float]
    attr_accessor :value
    # @return [Symbol]
    attr_accessor :unit

    def read(val)
      @value = val.value
      @unit = val.unit
      @args = Values.new
      if @unit == :parser_function && @value.args
        @value.args.each do |a|
          @args << Value.read(a)
        end
      end
      self
    end

    def string(indent = 0)
      case @unit
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :deg, :rad, :turn,
        :vw, :vh, :vmin, :vmax, :dppx, :dpi, :dpcm, :fr
        "#{value_i_or_f}#{@unit}"
      when :percentage
        "#{value_i_or_f}%"
      when :number
        "#{value_i_or_f}"
      when :ident
        @value
      when :parser_hexcolor
        "##{@value}"
      when :parser_operator
        @value
      when :parser_function
        "#{@value.name}#{@args.string})"
      when :string
        "'#{@value}'"
      when :uri
        "url(#{@value.include?(" ") ? "\"#{@value}\"" : @value})"
      when :unicode_range
        @value
      when :dimension # something is wrong with dimension
        @value
      when :unknown
        @value
      else
        raise "Unsupported value '#{@value}' #{@unit}"
      end
    end

    private

    def value_i_or_f
      return 0 unless @value
      @value.round == @value ? @value.round : @value
    end
  end

  class Values < Array
    def string(indent = 0)
      str = ""
      each_cons(2) do |val|
        str += val[0].string
        str += val[1].unit == :parser_operator || val[0].unit == :parser_operator ? "" : " "
      end
      str += last.string if last
      str
    end
  end
end
