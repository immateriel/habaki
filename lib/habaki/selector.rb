module Habaki
  # CSS selector
  class Selector < Node
    # Array of {SubSelectors} group
    # @return [Array<SubSelectors>]
    attr_accessor :sub_selectors

    def initialize
      @sub_selectors = []
    end

    # does selector match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @param [Specificity, nil] specificity
    # @return [Boolean]
    def element_match?(element, specificity = nil)
      return false if @sub_selectors.empty?

      current_sub_selector = nil
      @sub_selectors.reverse_each do |sub_selector|
        if current_sub_selector
          case current_sub_selector.relation
          when :descendant
            parent_element = element.parent
            sub_match = false
            while parent_element do
              sub_match = sub_selector.element_match?(parent_element, specificity)
              parent_element = parent_element.parent
              break if sub_match
            end
            return false unless sub_match
          when :child
            parent_element = element.parent
            return false unless parent_element
            return false unless sub_selector.element_match?(parent_element, specificity)
          when :direct_adjacent
            previous_element = element.previous
            return false unless previous_element
            return false unless sub_selector.element_match?(previous_element, specificity)
          when :indirect_adjacent
            previous_element = element.previous
            sub_match = false
            while previous_element do
              sub_match = sub_selector.element_match?(previous_element, specificity)
              previous_element = previous_element.previous
              break if sub_match
            end
            return false unless sub_match
          else
            # STDERR.puts "Habaki: unknown relation #{current_sub_selector.relation}"
            return false
          end
        else
          return false unless sub_selector.element_match?(element, specificity)
        end

        current_sub_selector = sub_selector
      end
      true
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      @sub_selectors.map do |sub_sel|
        sub_sel.string(format)
      end.join("")
    end

    # @api private
    # @param [Katana::Selector] sel
    def read_from_katana(sel)
      @sub_selectors = rec_sub_sel(sel)
    end

    private

    # parse sub selectors recursively
    def rec_sub_sel(sel)
      sub_sels = []
      cur_sel = sel
      cur_sub_sel = SubSelectors.new
      while cur_sel do
        cur_sub_sel << SubSelector.read_from_katana(cur_sel)
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
end
