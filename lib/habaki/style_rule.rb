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

    # does element match with rule ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def match?(element)
      selectors.match?(element)
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
