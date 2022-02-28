module Habaki
  # CSS selector
  class Selector < Node
    # @return [Array<SubSelectors>]
    attr_accessor :sub_selectors

    def initialize
      @sub_selectors = []
    end

    # does element match with this selector ?
    # @param [Visitor::Element] element
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
end
