module Habaki
  # CSS specificity score
  class Specificity
    attr_accessor :score

    def initialize
      @score = 0
    end
  end

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

    # does sub selector match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def element_match?(element, specificity = nil)
      case @match
      when :tag
        tag_match?(element.tag_name, specificity)
      when :class
        class_match?(element.class_name, specificity)
      when :id
        id_match?(element.id_name, specificity)
      when :pseudo_class
        pseudo_match?(element, specificity)
      else
        if attribute_selector?
          element_attr = element.attr(@attribute.local)
          (element_attr ? attribute_value_match?(element_attr, specificity) : false)
        else
          false
        end
      end
    end

    # does selector match tag ?
    # @param [String] name
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def tag_match?(name, specificity = nil)
      match_with_specificity(@tag.local == name, specificity, 1) || @tag.local == "*"
    end

    # does selector match class ?
    # @param [String] name
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def class_match?(name, specificity = nil)
      match_with_specificity(@value == name, specificity, 10)
    end

    # does selector match id ?
    # @param [String] name
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def id_match?(name, specificity = nil)
      match_with_specificity(@value == name, specificity, 100)
    end

    # does selector match attribute value ?
    # @param [String] val
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def attribute_value_match?(val, specificity = nil)
      match_with_specificity(
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
        end, specificity, 10)
    end

    # @param [Visitor::Element] element
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def pseudo_match?(element, specificity = nil)
      match_with_specificity(pseudo_class_match?(element), specificity, 10)
    end

    # does selector pseudo class match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def pseudo_class_match?(element)
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

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      str = ""

      if attribute_selector?
        str += "[#{@attribute.string(format)}"
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
          str += @tag.string(format)
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
            str += @selectors.string(format)
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

    private

    # @param [Boolean] comp
    # @param [Specificity, nil] specificity
    # @param [Integer] score
    # @return [Boolean]
    def match_with_specificity(comp, specificity, score)
      specificity.score += score if specificity && comp
      comp
    end

  end
end
