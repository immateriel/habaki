module Habaki
  class Value < Node
    # @return [::String, Float]
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    # @api private
    # @param [Katana::Value] val
    # @return [void]
    def read(val)
      @data = val.value
      self
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{@data}"
    end

    private

    def data_i_or_f
      return 0 unless @data
      @data.round == @data ? @data.round : @data
    end
  end

  # dimension in px, pt etc
  class Dimension < Value
    # @return [Symbol]
    attr_accessor :unit

    def initialize(data = nil, unit = nil)
      @data = data
      @unit = unit
    end

    # is dimension absolute ?
    # @return [Boolean]
    def absolute?
      [:cm, :mm, :in, :pt, :pc].include?(@unit)
    end

    # @api private
    # @return [void]
    def read(val)
      @data = val.value
      @unit = val.unit
      @unit = nil if @unit == :dimension
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      @unit ? "#{data_i_or_f}#{@unit}" : @data
    end
  end

  class Percentage < Value
    # @api private
    # @return [String]
    def string(indent = 0)
      "#{data_i_or_f}%"
    end
  end

  class Number < Value
    # @api private
    # @return [String]
    def string(indent = 0)
      "#{data_i_or_f}"
    end
  end

  class Ident < Value
  end

  class String < Value
    # @api private
    # @return [String]
    def string(indent = 0)
      "'#{@data}'"
    end
  end

  class Operator < Value
  end

  class HexColor < Value
    # @api private
    # @return [String]
    def string(indent = 0)
      "##{@data}"
    end
  end

  class Function < Value
    # @return [Values]
    attr_accessor :args

    # @api private
    # @param [Katana::Value] val
    # @return [void]
    def read(val)
      @data = val.value.name.sub("(","")
      @args = Values.new
      if val.value.args
        @args = Values.read(val.value.args)
      end
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{@data}(#{@args.string})"
    end
  end

  class Url < Value
    # @api private
    # @return [String]
    def string(indent = 0)
      "url(#{@data.include?(" ") ? "\"#{@data}\"" : @data})"
    end
  end

  class UnicodeRange < Value
  end

  # Array of {Values}
  class Values < Array
    extend NodeReader

    # @api private
    # @param [Katana::Array<Katana::Value>] vals
    # @return [void]
    def read(vals)
      vals.each do |val|
        push read_from_unit(val)
      end
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      str = ""
      each_cons(2) do |val|
        str += val[0].string
        str += val[1].is_a?(Operator) || val[0].is_a?(Operator) ? "" : " "
      end
      str += last.string if last
      str
    end

    private

    def read_from_unit(val)
      case val.unit
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :deg, :rad, :turn,
        :vw, :vh, :vmin, :vmax, :dppx, :dpi, :dpcm, :fr, :dimension
        Dimension.read(val)
      when :percentage
        Percentage.read(val)
      when :number
        Number.read(val)
      when :ident
        Ident.read(val)
      when :string
        String.read(val)
      when :parser_hexcolor
        HexColor.read(val)
      when :parser_function
        Function.read(val)
      when :parser_operator
        Operator.read(val)
      when :uri
        Url.read(val)
      when :unicode_range
        UnicodeRange.read(val)
      else
        # fallback
        Value.read(val)
      end
    end

  end
end
