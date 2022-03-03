module Habaki
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

    # does element match with this sub selector ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def match?(element)
      tag_match?(element.tag_name) && class_match?(element.class_name) && id_match?(element.id_name) &&
        attributes_match?(element) && pseudo_match?(element)
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

    private

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

    # @return [Boolean]
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
            match &&= ((parent_element&.children.index(element) + 1) % 2 == 1)
          when "even"
            match &&= ((parent_element&.children.index(element) + 1) % 2 == 0)
          when /^\d+$/
            match &&= parent_element&.children[sub_sel.argument.to_i - 1] == element
          when "n"
            match &&= ((parent_element&.children.index(element) + 1) % 1) == (arg[1]&.to_i || 0)
          when /n$/
            match &&= ((parent_element&.children.index(element) + 1) % arg[0].sub("n", "").to_i) == (arg[1]&.to_i || 0)
          else
            # TODO "of type"
            match &&= false
          end
        when :not
          match &&= !sub_sel.selectors.match?(element)
        when :not_parsed, :unknown
          match &&= true
        else
          # STDERR.puts "unsupported pseudo #{sub_sel.pseudo}"
          match &&= false
        end
      end
      match
    end
  end
end
