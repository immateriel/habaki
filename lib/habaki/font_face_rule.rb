module Habaki
  # Rule for @font-face
  class FontFaceRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "@font-face {#{@declarations.string(format)}}"
    end

    # @api private
    # @param [Katana::FontFaceRule] rule
    # @return [void]
    def read_from_katana(rule)
      @declarations = Declarations.read_from_katana(rule.declarations)
    end
  end
end
