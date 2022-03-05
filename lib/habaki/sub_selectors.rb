module Habaki
  # Array of {SubSelector}
  class SubSelectors < Array
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
end
