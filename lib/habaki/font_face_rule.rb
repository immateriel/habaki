module Habaki
  # Rule for @font-face
  class FontFaceRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @api private
    # @param [Katana::FontFaceRule] rule
    # @return [void]
    def read(rule)
      @declarations = Declarations.read(rule.declarations)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@font-face {#{@declarations.string(indent)}}"
    end
  end
end
