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

    # does rule match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def match?(element)
      selectors.match?(element)
    end

    # @return [String]
    def string(indent = 0)
      "#{@selectors.string} {#{@declarations.string(indent)}#{" " * (indent > 0 ? indent - 1 : 0)}}"
    end

    # @api private
    # @param [Katana::StyleRule] rule
    # @return [void]
    def read_from_katana(rule)
      @selectors = Selectors.read_from_katana(rule.selectors)
      @declarations = Declarations.read_from_katana(rule.declarations)
    end
  end
end
