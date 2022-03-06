module Habaki
  # Array of {SubSelector}
  class SubSelectors < NodeArray
    # @return [Symbol]
    attr_accessor :relation

    # does selector match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def element_match?(element)
      each do |sub_sel|
        case sub_sel.match
        when :tag
          return false unless sub_sel.tag_match?(element.tag_name)
        when :class
          return false unless sub_sel.class_match?(element.class_name)
        when :id
          return false unless sub_sel.id_match?(element.id_name)
        else
          if sub_sel.attribute_selector?
            element_attr = element.attr(sub_sel.attribute.local)
            return false unless element_attr ? sub_sel.attribute_value_match?(element_attr) : false
          end
        end
        return false unless sub_sel.pseudo_match?(element)
      end
      true
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{string_relation}#{string_join(format, "")}"
    end

    private

    def string_relation
      case @relation
      when :descendant
        " "
      when :child
        " > "
      when :direct_adjacent
        " + "
      when :indirect_adjacent
        " ~ "
      else
        ""
      end
    end

  end
end
