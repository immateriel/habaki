module Habaki
  # partially adapted from css_parser https://github.com/premailer/css_parser/blob/master/lib/css_parser/rule_set.rb
  module Shorthand
    BORDER_PROPERTIES = %w[border border-left border-right border-top border-bottom].freeze
    BORDER_STYLES = %[none hidden dotted dashed solid double groove ridge inset outset].freeze

    NUMBER_OF_DIMENSIONS = 4

    DIMENSIONS = [
      ['margin', %w[margin-top margin-right margin-bottom margin-left]],
      ['padding', %w[padding-top padding-right padding-bottom padding-left]],
      ['border-color', %w[border-top-color border-right-color border-bottom-color border-left-color]],
      ['border-style', %w[border-top-style border-right-style border-bottom-style border-left-style]],
      ['border-width', %w[border-top-width border-right-width border-bottom-width border-left-width]]
    ].freeze

    # Split shorthand declarations (e.g. +margin+ or +font+) into their constituent parts.
    def expand_shorthand!
      # border must be expanded before dimensions
      expand_border_shorthand!
      expand_dimensions_shorthand!
      expand_font_shorthand!
      # expand_background_shorthand!
      expand_list_style_shorthand!
    end

    # Convert shorthand background declarations (e.g. <tt>background: url("chess.png") gray 50% repeat fixed;</tt>)
    # into their constituent parts.
    #
    # See http://www.w3.org/TR/CSS21/colors.html#propdef-background
    # TODO
    def expand_background_shorthand! # :nodoc:
      expand_shorthand_properties!("background")
    end

    # Split shorthand border declarations (e.g. <tt>border: 1px red;</tt>)
    # Additional splitting happens in expand_dimensions_shorthand!
    def expand_border_shorthand! # :nodoc:
      BORDER_PROPERTIES.each do |k|
        next unless (declaration = find_by_property(k))

        shorted = true
        case declaration.values.length
        when 1
          add_by_property("#{k}-style", declaration.values[0], declaration.important)
        when 2
          if BORDER_STYLES.include?(declaration.values[0].data)
            add_by_property("#{k}-style", declaration.values[0])
            add_by_property("#{k}-color", declaration.values[1])
          else
            if BORDER_STYLES.include?(declaration.values[1].data)
              add_by_property("#{k}-width", declaration.values[0])
              add_by_property("#{k}-style", declaration.values[1])
            else
              shorted = false
            end
          end
        when 3
          add_by_property("#{k}-width", declaration.values[0])
          add_by_property("#{k}-style", declaration.values[1])
          add_by_property("#{k}-color", declaration.values[2])
        end

        remove_by_property(k) if shorted
      end
    end

    # Split shorthand dimensional declarations (e.g. <tt>margin: 0px auto;</tt>)
    # into their constituent parts.  Handles margin, padding, border-color, border-style and border-width.
    def expand_dimensions_shorthand! # :nodoc:
      DIMENSIONS.each do |property, (top, right, bottom, left)|
        next unless (declaration = find_by_property(property))

        case declaration.values.length
        when 1
          values = declaration.values * 4
        when 2
          values = declaration.values * 2
        when 3
          values = declaration.values
          values << declaration.values[1] # left = right
        when 4
          values = declaration.values
        else
          raise ArgumentError, "Cannot parse #{declaration.values}"
        end

        replacement = [top, right, bottom, left].zip(values).to_h

        position = find_by_property(property)&.position
        remove_by_property(property)

        replacement.each do |short_prop, value|
          decl = add_by_property(short_prop, value)
          decl.position = position
        end
      end
    end

    # Convert shorthand font declarations (e.g. <tt>font: 300 italic 11px/14px verdana, helvetica, sans-serif;</tt>)
    # into their constituent parts.
    def expand_font_shorthand! # :nodoc:
      expand_shorthand_properties!("font")
    end

    # Convert shorthand list-style declarations (e.g. <tt>list-style: lower-alpha outside;</tt>)
    # into their constituent parts.
    #
    # See http://www.w3.org/TR/CSS21/generate.html#lists
    def expand_list_style_shorthand! # :nodoc:
      expand_shorthand_properties!("list-style")
    end

    def expand_shorthand_properties!(property)
      return unless (declaration = find_by_property(property))

      matcher = FormalSyntax::Matcher.new(declaration)
      return unless matcher.match?

      props = {}
      matcher.matches.each do |match|
        next if match.value.is_a?(Operator) && match.value.data == "/" # font-size/line-height
        props[match.reference] ||= Values.new
        props[match.reference] << match.value
      end

      props.each do |k, v|
        new_decl = add_by_property(k, Values.new([v].flatten))
        new_decl.position = declaration.position
      end

      remove_by_property(property)
    end

    # Create shorthand declarations (e.g. +margin+ or +font+) whenever possible.
    def create_shorthand!
      # create_background_shorthand!
      create_dimensions_shorthand!
      # border must be shortened after dimensions
      create_border_shorthand!
      create_font_shorthand!
      create_list_style_shorthand!
    end

    # Combine several properties into a shorthand one
    def create_shorthand_properties!(shorthand_property, need_all = false)
      properties_to_delete = []

      new_values = []
      FormalSyntax::Tree.tree.property(shorthand_property).traverse do |node|
        case node.type
        when :ref
          decl = find_by_property(node.value)
          if decl
            properties_to_delete << decl.property
            new_values += decl.values
          else
            return if need_all
          end
        when :token
          new_values << Operator.new(node.value) unless new_values.empty?
        end
      end

      return if new_values.empty?

      first_position = find_by_property(properties_to_delete.first)&.position
      properties_to_delete.each do |property|
        remove_by_property(property)
      end

      new_decl = add_by_property(shorthand_property, new_values)
      new_decl.position = first_position
    end

    # Looks for long format CSS background properties (e.g. <tt>background-color</tt>) and
    # converts them into a shorthand CSS <tt>background</tt> property.
    #
    # Leaves properties declared !important alone.
    def create_background_shorthand! # :nodoc:
      # When we have a background-size property we must separate it and distinguish it from
      # background-position by preceding it with a backslash. In this case we also need to
      # have a background-position property, so we set it if it's missing.
      # http://www.w3schools.com/cssref/css3_pr_background.asp
      if (declaration = find_by_property('background-size')) && !declaration.important
        add_by_property('background-position', Values.new([Percentage.new(0), Percentage.new(0)]))
        declaration.values = Values.new([Operator.new('/'), declaration.value])
      end

      create_shorthand_properties! 'background'
    end

    # Combine border-color, border-style and border-width into border
    # Should be run after create_dimensions_shorthand!
    #
    # TODO: this is extremely similar to create_background_shorthand! and should be combined
    def create_border_shorthand! # :nodoc:
      border_style_properties = %w[border-width border-style border-color]
      values = Values.new(border_style_properties.map do |property|
        next unless (declaration = find_by_property(property))
        next if declaration.important
        # can't merge if any value contains a space (i.e. has multiple values)
        # we temporarily remove any spaces after commas for the check (inside rgba, etc...)
        next if declaration.values.length > 1

        declaration.value
      end.compact)

      return if values.length != border_style_properties.length

      first_position = find_by_property(border_style_properties.first)&.position
      border_style_properties.each do |property|
        remove_by_property(property)
      end

      new_decl = add_by_property('border', values)
      new_decl.position = first_position
    end

    # Looks for long format CSS font properties (e.g. <tt>font-weight</tt>) and
    # tries to convert them into a shorthand CSS <tt>font</tt> property.  All
    # font properties must be present in order to create a shorthand declaration.
    def create_font_shorthand! # :nodoc:
      #create_shorthand_properties!("font", true)
      properties = %w[font-style font-variant font-weight font-size line-height font-family]

      values = []
      properties.each do |prop|
        decl = find_by_property(prop)
        return unless decl

        values << Habaki::Operator.new("/") if prop == "line-height"
        values += decl.values
      end

      first_position = find_by_property(properties.first)&.position
      properties.each do |property|
        remove_by_property(property)
      end
      new_decl = add_by_property("font", values)
      new_decl.position = first_position
    end

    # Looks for long format CSS list-style properties (e.g. <tt>list-style-type</tt>) and
    # converts them into a shorthand CSS <tt>list-style</tt> property.
    #
    # Leaves properties declared !important alone.
    def create_list_style_shorthand! # :nodoc:
      create_shorthand_properties! 'list-style'
    end

    # Looks for long format CSS dimensional properties (margin, padding, border-color, border-style and border-width)
    # and converts them into shorthand CSS properties.
    def create_dimensions_shorthand! # :nodoc:
      return if length < NUMBER_OF_DIMENSIONS

      DIMENSIONS.each do |property, dimensions|
        values = [:top, :right, :bottom, :left].each_with_index.with_object({}) do |(side, index), result|
          next unless (declaration = find_by_property(dimensions[index]))
          result[side] = declaration.value
        end

        # All four dimensions must be present
        next if values.length != dimensions.length

        new_values = Values.new(values.values_at(*compute_dimensions_shorthand(values)))
        unless new_values.empty?
          first_position = find_by_property(dimensions.first)&.position
          decl = add_by_property(property, new_values)
          decl.position = first_position
        end

        # Delete the longhand values
        dimensions.each do |prop|
          remove_by_property(prop)
        end
      end
    end

    def compute_dimensions_shorthand(values)
      # All four sides are equal, returning single value
      return [:top] if values.values.uniq.count == 1

      # `/* top | right | bottom | left */`
      return [:top, :right, :bottom, :left] if values[:left] != values[:right]

      # Vertical are the same & horizontal are the same, `/* vertical | horizontal */`
      return [:top, :left] if values[:top] == values[:bottom]

      [:top, :left, :bottom]
    end
  end

  # Array of {Declaration}
  class Declarations < NodeArray
    include Shorthand

    # Parse inline declarations
    # @param [String] data
    # @return [Declarations]
    def self.parse(data)
      decls = self.new
      decls.parse!(data)
      decls
    end

    # Parse inline declarations and append to current declarations
    # @param [String] data
    # @return [void]
    def parse!(data)
      return unless data

      out = Katana.parse_inline(data)
      if out.declarations
        read_from_katana(out.declarations)
      end
    end

    # Find declaration with property
    # @param [String] property
    # @return [Declaration]
    def find_by_property(property)
      select { |decl| decl.property == property }.first
    end

    # Remove declaration with property
    # @param [String] property
    # @return [void]
    def remove_by_property(property)
      reject! { |decl| decl.property == property }
    end

    # Add declaration
    # @param [String] property
    # @param [Value, Values, Array<Value>] value
    # @param [Boolean] important
    # @return [Declaration]
    def add_by_property(property, value, important = false)
      decl = Habaki::Declaration.new(property, important)
      decl.values = Values.new([value].flatten)
      push decl
      decl
    end

    # @return [String]
    def string(indent = 0)
      str = ""
      str += "\n" if indent > 0
      each { |decl|
        str += decl.string(indent)
        str += indent > 0 ? ";\n" : "; "
      }
      str
    end

    # @api private
    # @param [Katana::Array<Katana::Declaration>] decls
    # @return [void]
    def read_from_katana(decls)
      decls.each do |decl|
        push Declaration.read_from_katana(decl)
      end
    end
  end
end
