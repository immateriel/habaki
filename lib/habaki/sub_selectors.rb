module Habaki
  # Array of {SubSelector}
  class SubSelectors < NodeArray
    # @return [Symbol]
    attr_accessor :relation

    def initialize(*args)
      super(*args)

      @relation = nil
    end

    # does every sub selectors match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def element_match?(element, specificity = nil)
      each do |sub_sel|
        return false unless sub_sel.element_match?(element, specificity)
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
