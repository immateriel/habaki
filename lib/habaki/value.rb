module Habaki
  # abstract value type
  class Value < Node
    # @return [::String, Float]
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    # @api private
    # @param [Katana::Value] val
    # @return [void]
    def read_from_katana(val)
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

  # <length> value type in px, pt etc
  class Length < Value
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
      return 0.0 if default_px == 0.0
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
    def read_from_katana(val)
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

  # <angle> value type in deg, rad
  class Angle < Value
    # @return [Symbol]
    attr_accessor :unit

    def initialize(data = nil, unit = nil)
      @data = data
      @unit = unit
    end

    # @return [String]
    def string(indent = 0)
      @unit ? "#{data_i_or_f}#{@unit}" : @data
    end

    # @api private
    # @return [void]
    def read_from_katana(val)
      @data = val.value
      @unit = val.unit
      @unit = nil if @unit == :dimension
    end
  end

  # <percentage> value type
  class Percentage < Value
    # @return [Float]
    def to_f
      @data
    end

    # @return [String]
    def string(indent = 0)
      "#{data_i_or_f}%"
    end
  end

  # <number> or <integer> value type
  class Number < Value
    # @return [Float]
    def to_f
      @data
    end

    # @return [Integer]
    def to_i
      @data.to_i
    end

    # @return [String]
    def string(indent = 0)
      "#{data_i_or_f}"
    end
  end

  # <ident> value type
  class Ident < Value
  end

  # <string> value type
  class String < Value
    # @return [String]
    def string(indent = 0)
      "'#{@data}'"
    end
  end

  # operator , or /
  class Operator < Value
  end

  # <hex-color> value type
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

    # @return [String]
    def string(indent = 0)
      "#{@data}(#{@args.string})"
    end

    # @api private
    # @param [Katana::Value] val
    # @return [void]
    def read_from_katana(val)
      @data = val.value.name.sub("(", "")
      @args = Values.new
      if val.value.args
        @args = Values.read_from_katana(val.value.args)
      end
    end
  end

  # <url>/<uri> value type
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

    # @return [String]
    def string(indent = 0)
      "url(#{@data.include?(" ") ? "\"#{@data}\"" : @data})"
    end
  end

  class UnicodeRange < Value
  end
end
