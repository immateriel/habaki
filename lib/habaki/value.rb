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

  # TODO: rename to Length
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
      [:px, :cm, :mm, :in, :pt, :pc].include?(@unit)
    end

    # is dimension relative ?
    # @return [Boolean]
    def relative?
      [:em, :ex, :ch, :rem, :vw, :vh, :vmin, :vmax].include?(@unit)
    end

    # absolute value to pixel
    # @return [Float, nil]
    def to_px(ppi = 96)
      case @unit
      when :px
        @data
      when :cm
        (@data / 2.54) * ppi
      when :mm
        ((@data / 10.0) / 2.54) * ppi
      when :in
        @data * ppi
      when :pt
        @data / (72.0 / ppi)
      when :pc
        (@data * 12.0) / (72.0 / ppi)
      else
        # relative
      end
    end

    # absolute value to em
    # @return [Float, nil]
    def to_em(default_px = 16.0)
      if absolute?
        to_px / default_px
      else
        case @unit
        when :em
          @data
        end
      end
    end

    # @return [Float]
    def to_f
      @data.is_a?(Float) ? @data : 0.0
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

  class Angle < Value
    # @return [Symbol]
    attr_accessor :unit

    def initialize(data = nil, unit = nil)
      @data = data
      @unit = unit
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
    # @return [Float]
    def to_f
      @data
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{data_i_or_f}%"
    end
  end

  class Number < Value
    # @return [Float]
    def to_f
      @data
    end

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
      @data = val.value.name.sub("(", "")
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
    # is url of data type ?
    # @return [Boolean]
    def data_uri?
      @data.start_with?("data:")
    end

    # @return [String]
    def uri
      @data
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "url(#{@data.include?(" ") ? "\"#{@data}\"" : @data})"
    end
  end

  class UnicodeRange < Value
  end

  # Array of {Values}
  class Values < NodeArray
    # traverse values with optional class type
    # @param [Class] klass
    # @return [void]
    def each_value(klass = nil, &block)
      each do |value|
        block.call value if !klass || value.is_a?(klass)
      end
    end

    # remove value taking care of operator in list
    # @param [Value] value
    # @return [void]
    def remove_value(value)
      idx = index(value)
      prev_val = at(idx - 1)
      next_val = at(idx + 1)
      if prev_val&.is_a?(Operator)
        delete(prev_val)
      elsif next_val&.is_a?(Operator)
        delete(next_val)
      end
      delete(value)
    end

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
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :turn,
        :vw, :vh, :vmin, :vmax, :dppx, :dpi, :dpcm, :fr, :dimension
        Dimension.read(val)
      when :deg, :rad, :grad
        Angle.read(val)
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
