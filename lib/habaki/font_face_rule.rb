module Habaki
  # Rule for @font-face
  class FontFaceRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @return [String]
    def string(indent = 0)
      "@font-face {#{@declarations.string(indent)}}"
    end

    # @api private
    # @param [Katana::FontFaceRule] rule
    # @return [void]
    def read_from_katana(rule)
      @declarations = Declarations.read_from_katana(rule.declarations)
    end
  end
end
