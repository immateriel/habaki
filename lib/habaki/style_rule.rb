module Habaki
  # CSS style rule selectors + declarations
  class StyleRule < Rule
    # @return [Selectors]
    attr_accessor :selectors
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @selectors = Selectors.new
      @declarations = Declarations.new
    end

    # select elements for this selector
    # @param [Visitor::Element] element
    # @return [Array<Visitor::Element>]
    def matches(element)
      selectors.matches(element)
    end

    # @api private
    # @param [Katana::StyleRule] rule
    # @return [void]
    def read(rule)
      @selectors = Selectors.read(rule.selectors)
      @declarations = Declarations.read(rule.declarations)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{@selectors.string} {#{@declarations.string(indent)}#{" " * (indent > 0 ? indent - 1 : 0)}}"
    end
  end
end
