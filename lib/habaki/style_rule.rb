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
    def element_match?(element)
      selectors.element_match?(element)
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{@selectors.string(format)} {#{format.declarations_prefix}#{@declarations.string(format+1)}#{format.declarations_suffix}#{format.rules_prefix}}"
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
