module Habaki
  # part of selector (eg in p.t, p is a tag subselector and .t a class subselector)
  class SubSelector < Node
    # @return [Symbol]
    attr_accessor :match
    # @return [String]
    attr_accessor :tag
    # @return [Symbol]
    attr_accessor :pseudo

    # @return [String]
    attr_accessor :attribute
    # @return [String]
    attr_accessor :value
    # @return [String]
    attr_accessor :argument
    # @return [Selectors]
    attr_accessor :selectors

    # @return [SourcePosition]
    attr_accessor :position

    # is this selector on attribute ?
    # @return [Boolean]
    def attribute_selector?
      @match.to_s.start_with?("attribute_")
    end

    # does selector match tag ?
    # @param [String] name
    # @return [Boolean]
    def tag_match?(name)
      return nil unless @match == :tag
      @tag.local == name || @tag.local == "*"
    end

    # does selector match class ?
    # @param [String] name
    # @return [Boolean]
    def class_match?(name)
      return nil unless @match == :class
      @value == name
    end

    # does selector match id ?
    # @param [String] name
    # @return [Boolean]
    def id_match?(name)
      return nil unless @match == :id
      @value == name
    end

    # does selector match attribute value ?
    # @param [String] val
    # @return [Boolean]
    def attribute_value_match?(val)
      if attribute_selector?
        case @match
        when :attribute_exact
          val == @value
        when :attribute_begin
          val.start_with?(@value)
        when :attribute_end
          val.end_with?(@value)
        when :attribute_contain
          val.include?(@value)
        when :attribute_hyphen
          val == @value || val == "#{@value}-"
        else
          false
        end
      end
    end

    # does selector pseudo class match {Visitor::Element} ?
    # @return [Boolean]
    def pseudo_match?(element)
      case @pseudo
      when :root
        return false unless element.tag_name == "html"
      when :empty
        return false unless element.children.empty?
      when :first_child
        parent_element = element.parent
        return false unless parent_element&.children.first == element
      when :last_child
        parent_element = element.parent
        return false unless parent_element&.children.last == element
      when :only_child
        parent_element = element.parent
        return false unless parent_element&.children.length == 1 && parent_element&.children.first == element
      when :nth_child
        parent_element = element.parent
        arg = @argument.split("+")
        case arg[0]
        when "odd"
          return false unless ((parent_element&.children.index(element) + 1) % 2 == 1)
        when "even"
          return false unless ((parent_element&.children.index(element) + 1) % 2 == 0)
        when /^\d+$/
          return false unless parent_element&.children[@argument.to_i - 1] == element
        when "n"
          return false unless ((parent_element&.children.index(element) + 1) % 1) == (arg[1]&.to_i || 0)
        when /n$/
          return false unless ((parent_element&.children.index(element) + 1) % arg[0].sub("n", "").to_i) == (arg[1]&.to_i || 0)
        else
          # TODO "of type"
          return false
        end
      when :not
        return false unless !@selectors.element_match?(element)
      when :not_parsed, :unknown
      else
        # STDERR.puts "unsupported pseudo #{sub_sel.pseudo}"
        return false
      end
      true
    end

    # @return [String]
    def string(indent = 0)
      str = ""

      if attribute_selector?
        str += "[#{@attribute.string}"
        case @match
        when :attribute_exact
          str += "="
        when :attribute_set
          str += "]"
        when :attribute_list
          str += "~="
        when :attribute_hyphen
          str += "|="
        when :attribute_begin
          str += "^="
        when :attribute_end
          str += "$="
        when :attribute_contain
          str += "*="
        end
        str += "\"#{@value}\"]" if @match != :attribute_set
      else
        case @match
        when :tag
          str += @tag.string
        when :class
          str += ".#{@value}"
        when :id
          str += "##{@value}"
        when :attribute_contain
          str += "*="
        when :pseudo_class, :pseudo_page_class
          str += ":#{@value}"
          case @pseudo
          when :any, :not, :host, :host_context
            str += @selectors.string
            str += ")"
          when :lang, :nth_child, :nth_last_child, :nth_of_type, :nth_last_of_type
            str += "#{@argument})"
          end
        when :pseudo_element
          str += "::#{@value}"
        end
      end
      str
    end

    # @api private
    # @param [Katana::Selector] sel
    def read_from_katana(sel)
      @match = sel.match
      @tag = QualifiedName.read_from_katana(sel.tag) if sel.tag
      @pseudo = sel.pseudo

      @attribute = QualifiedName.read_from_katana(sel.data.attribute) if sel.data.attribute
      @value = sel.data.value
      @argument = sel.data.argument

      @selectors = Selectors.read_from_katana(sel.data.selectors) if sel.data.selectors

      @position = SourcePosition.new(sel.position.line, sel.position.column)
    end
  end
end
