module Habaki
  # name with optionnal prefix
  class QualifiedName < Node
    attr_accessor :local, :prefix

    # @api private
    # @param [Katana::QualifiedName] tag
    def read(tag)
      @local = tag.local
      @prefix = tag.prefix
    end

    # @api private
    def string(indent = 0)
      @prefix ? "#{@prefix}|#{@local}" : @local
    end
  end

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
      @tag.local == name
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

  # @abstract CSS selector element visitor
  class SelectorVisitor
    # element tag name
    # @return [String]
    def tag_name
    end

    # element class name
    # @return [String]
    def class_name
    end

    # element id name
    # @return [String]
    def id_name
    end

    # element attribute
    # @param [String] key
    # @return [String]
    def attr(key) end

    # inner text
    # @return [String]
    def text
    end

    # element parent
    # @return [SelectorVisitor]
    def parent
    end

    # element previous
    # @return [SelectorVisitor]
    def previous
    end

    # @return [Array<SelectorVisitor>]
    def children
      []
    end

    # traverse elements
    def traverse &block
    end
  end

  class NokogiriSelectorVisitor < SelectorVisitor
    attr_accessor :element

    def initialize(element)
      @element = element
    end

    def tag_name
      @element.name
    end

    def class_name
      @element["class"]
    end

    def id_name
      @element["id"]
    end

    def attr(key)
      @element[key]
    end

    def text
      @element.text
    end

    def parent
      NokogiriSelectorVisitor.new(@element.parent) if @element.respond_to?(:parent)
    end

    def previous
      NokogiriSelectorVisitor.new(@element.previous_element) if @element.respond_to?(:previous_element) && @element.previous_element
    end

    def children
      @element.children.map do |child|
        child.is_a?(Nokogiri::XML::Element) ? NokogiriSelectorVisitor.new(child) : nil
      end.compact
    end

    def traverse &block
      @element.traverse do |el|
        next unless el.is_a?(Nokogiri::XML::Element)
        block.call NokogiriSelectorVisitor.new(el)
      end
    end

    def ==(other)
      @element == other.element
    end
  end

  # Array of {SubSelector}
  class SubSelectors < Array
    # @return [Symbol]
    attr_accessor :relation

    # @return [SubSelector]
    def tag_selector
      select { |sub_sel| sub_sel.match == :tag }.first
    end

    # @return [SubSelector]
    def class_selector
      select { |sub_sel| sub_sel.match == :class }.first
    end

    # @return [SubSelector]
    def id_selector
      select { |sub_sel| sub_sel.match == :id }.first
    end

    # @return [Array<SubSelector>]
    def attribute_selectors
      select { |sub_sel| sub_sel.attribute_selector? }
    end

    # @param [String] name
    # @return [Boolean]
    def tag_match?(name)
      tag_selector ? tag_selector.tag_match?(name) : true
    end

    # @param [String] name
    # @return [Boolean]
    def class_match?(name)
      class_selector ? class_selector.class_match?(name) : true
    end

    # @param [String] name
    # @return [Boolean]
    def id_match?(name)
      id_selector ? id_selector.id_match?(name) : true
    end

    # @return [Boolean]
    def attributes_match?(element)
      if attribute_selectors.length > 0
        match = true
        attribute_selectors.each do |attr|
          element_attr = element.attr(attr.attribute.local)
          match &&= element_attr ? attr.attribute_value_match?(element_attr) : false
        end
        match
      else
        true
      end
    end

    def pseudo_match?(element)
      match = true
      each do |sub_sel|
        case sub_sel.pseudo
        when :root
          match &&= element.tag_name == "html"
        when :empty
          match &&= element.children.length == 0
        when :first_child
          parent_element = element.parent
          match &&= parent_element&.children.first == element
        when :last_child
          parent_element = element.parent
          match &&= parent_element&.children.last == element
        when :only_child
          parent_element = element.parent
          match &&= parent_element&.children.length == 1 && parent_element&.children.first == element
        when :nth_child
          parent_element = element.parent
          arg = sub_sel.argument.split("+")
          case arg[0]
          when "odd"
            match &&= ((parent_element&.children.index(element)+1) % 2 == 1)
          when "even"
            match &&= ((parent_element&.children.index(element)+1) % 2 == 0)
          when /^\d+$/
            match &&= parent_element&.children[sub_sel.argument.to_i - 1] == element
          when "n"
            match &&= ((parent_element&.children.index(element)+1) % 1) == (arg[1]&.to_i||0)
          when /n$/
            match &&= ((parent_element&.children.index(element)+1) % arg[0].sub("n","").to_i) == (arg[1]&.to_i||0)
          else
            # invalid ?
            match &&= false
          end
        else
          match &&= true
        end
      end
      match
    end

    # does element match with this sub selector ?
    # @param [SelectorVisitor] element
    # @return [Boolean]
    def match?(element)
      tag_match?(element.tag_name) && class_match?(element.class_name) && id_match?(element.id_name) && attributes_match?(element) && pseudo_match?(element)
    end

    # @api private
    def string(indent = 0)
      str = ""
      case @relation
      when :descendant
        str += " "
      when :child
        str += " > "
      when :direct_adjacent
        str += " + "
      when :indirect_adjacent
        str += " ~ "
      end
      each do |sub_sel|
        str += sub_sel.string
      end
      str
    end
  end

  # CSS selector
  class Selector < Node
    # @return [Array<SubSelectors>]
    attr_accessor :sub_selectors

    def initialize
      @sub_selectors = []
    end

    # does element match with this selector ?
    # @param [SelectorVisitor] element
    # @return [Boolean]
    def match?(element)
      return false if @sub_selectors.length == 0

      rev_sub_selectors = @sub_selectors.reverse
      match = true

      current_sub_selector = rev_sub_selectors.first
      match &&= current_sub_selector.match?(element)

      if rev_sub_selectors.length > 1 && match
        parent_element = element.parent
        previous_element = element.previous

        rev_sub_selectors[1..-1].each do |sub_selector|
          case current_sub_selector.relation
          when :descendant
            sub_match = false
            while parent_element do
              sub_match = sub_selector.match?(parent_element)
              parent_element = parent_element.parent
              break if sub_match
            end
            match &&= sub_match
          when :child
            if parent_element
              sub_match = sub_selector.match?(parent_element)
              match &&= sub_match
            end
          when :direct_adjacent
            if previous_element
              sub_match = sub_selector.match?(previous_element)
              match &&= sub_match
            end
          when :indirect_adjacent
            sub_match = false
            while previous_element do
              sub_match = sub_selector.match?(previous_element)
              previous_element = previous_element.previous
              break if sub_match
            end
            match &&= sub_match
          end
          current_sub_selector = sub_selector
        end
      end
      match
    end

    # select elements for this selector
    # @param [SelectorVisitor]
    # @reutnr [Array<SelectorVisitor>]
    def select(element)
      match_elements = []
      element.traverse do |el|
        match_elements << el if match?(el)
      end
      match_elements
    end

    # @api private
    # @param [Katana::Selector] sel
    def read(sel)
      @sub_selectors = rec_sub_sel(sel)
    end

    # @api private
    def string(indent = 0)
      @sub_selectors.map(&:string).join("")
    end

    private

    # parse sub selectors recursively
    def rec_sub_sel(sel)
      sub_sels = []
      cur_sel = sel
      cur_sub_sel = SubSelectors.new
      while cur_sel do
        cur_sub_sel << SubSelector.read(cur_sel)
        break if cur_sel.relation != :sub_selector || !cur_sel.tag_history
        cur_sel = cur_sel.tag_history
      end

      cur_sub_sel.relation = cur_sel.relation if cur_sel.relation != :sub_selector
      sub_sels << cur_sub_sel

      if cur_sel.relation != :sub_selector
        sub_sels = rec_sub_sel(cur_sel.tag_history) + sub_sels
      end
      sub_sels
    end
  end

  # Array of {Selectors}
  class Selectors < Array
    extend NodeReader

    # @api private
    # @param [Katana::Array<Katana::Selector>] sels
    def read(sels)
      sels.each do |sel|
        push Selector.read(sel)
      end
    end

    # @api private
    def string(indent = 0)
      map(&:string).join(",")
    end
  end
end
