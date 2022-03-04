module Habaki
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

    # @api private
    # @param [Katana::Array<Katana::Value>] vals
    # @return [void]
    def read_from_katana(vals)
      vals.each do |val|
        push read_from_unit(val)
      end
    end

    private

    def read_from_unit(val)
      case val.unit
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :turn,
        :vw, :vh, :vmin, :vmax, :dppx, :dpi, :dpcm, :fr, :dimension
        Length.read_from_katana(val)
      when :deg, :rad, :grad
        Angle.read_from_katana(val)
      when :percentage
        Percentage.read_from_katana(val)
      when :number
        Number.read_from_katana(val)
      when :ident
        Ident.read_from_katana(val)
      when :string
        String.read_from_katana(val)
      when :parser_hexcolor
        HexColor.read_from_katana(val)
      when :parser_function
        Function.read_from_katana(val)
      when :parser_operator
        Operator.read_from_katana(val)
      when :uri
        Url.read_from_katana(val)
      when :unicode_range
        UnicodeRange.read_from_katana(val)
      else
        # fallback
        Value.read_from_katana(val)
      end
    end

  end
end
