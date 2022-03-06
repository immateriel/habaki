module Habaki
  # abstract value type
  class Value < Node
    # @return [::String, Float]
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def ==(other)
      to_s == other.to_s
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{@data}"
    end

    # @api private
    # @param [Katana::Value] val
    # @return [void]
    def read_from_katana(val)
      @data = val.value
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

    # @return [Length]
    def +(other)
      case other
      when Length
        raise ArgumentError, "cannot addition with different units" unless @unit == other.unit
        Length.new(@data + other.data, @unit)
      else
        raise ArgumentError, "cannot addition #{self.class} with #{other.class}"
      end
    end

    # @return [Length]
    def -(other)
      case other
      when Length
        raise ArgumentError, "cannot substract with different units" unless @unit == other.unit
        Length.new(@data - other.data, @unit)
      else
        raise ArgumentError, "cannot substract #{self.class} with #{other.class}"
      end
    end

    # @return [Length]
    def *(other)
      case other
      when Integer, Float
        Length.new((@data * other).round(3), @unit)
      when Percentage
        Length.new((@data * other.data/100.0).round(3), @unit)
      else
        raise ArgumentError, "cannot multiply #{self.class} with #{other.class}"
      end
    end

    # @return [Length]
    def /(other)
      case other
      when Integer, Float
        Length.new((@data / other).round(3), @unit)
      else
        raise ArgumentError, "cannot divide #{self.class} with #{other.class}"
      end
    end

    include Comparable

    # @return [Integer]
    def <=>(other)
      raise ArgumentError, "cannot compare #{self.class} with #{other.class}" unless other.is_a?(Length)
      if @unit == other.unit
        @data <=> other.data
      elsif absolute? && other.absolute?
        to_px <=> other.to_px
      else
        nil
      end
    end

    # @return [Boolean]
    def ==(other)
      return false unless other.is_a?(Length)
      if @unit == other.unit
        @data == other.data
      elsif absolute? && other.absolute?
        to_px == other.to_px
      else
        false
      end
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
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

  # <angle> value type in deg, rad
  class Angle < Value
    # @return [Symbol]
    attr_accessor :unit

    def initialize(data = nil, unit = nil)
      @data = data
      @unit = unit
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
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

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
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

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{data_i_or_f}"
    end
  end

  # <ident> value type
  class Ident < Value
  end

  # <string> value type
  class String < Value
    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{format.quote}#{@data}#{format.quote}"
    end
  end

  # operator , or /
  class Operator < Value
  end

  # <hex-color> value type
  class HexColor < Value
    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "##{@data}"
    end
  end

  class Function < Value
    # @return [Values]
    attr_accessor :args

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
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

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "url(#{@data.include?(" ") ? "#{format.quote}#{@data}#{format.quote}" : @data})"
    end
  end

  class UnicodeRange < Value
  end
end
