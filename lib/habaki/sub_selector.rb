module Habaki
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

    # is this selector on attribute ?
    # @return [Boolean]
    def attribute_selector?
      @match.to_s.start_with?("attribute_")
    end

    # tag match
    # @param [String] name
    # @return [Boolean]
    def tag_match?(name)
      return nil unless @match == :tag
      @tag.local == name || @tag.local == "*"
    end

    # class match
    # @param [String] name
    # @return [Boolean]
    def class_match?(name)
      return nil unless @match == :class
      @value == name
    end

    # id match
    # @param [String] name
    # @return [Boolean]
    def id_match?(name)
      return nil unless @match == :id
      @value == name
    end

    # attribute match
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
      else
        nil
      end
    end

    # @api private
    # @param [Katana::Selector] sel
    def read(sel)
      @match = sel.match
      @tag = QualifiedName.read(sel.tag) if sel.tag
      @pseudo = sel.pseudo

      @attribute = QualifiedName.read(sel.data.attribute) if sel.data.attribute
      @value = sel.data.value
      @argument = sel.data.argument

      @selectors = Selectors.read(sel.data.selectors) if sel.data.selectors
    end

    # @api private
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
  end
end
