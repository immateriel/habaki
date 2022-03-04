module Habaki
  # page rule @page
  class PageRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @return [String]
    def string(indent = 0)
      "@page {#{@declarations.string(indent)}}"
    end

    # @api private
    # @param [Katana::PageRule] rule
    # @return [void]
    def read_from_katana(rule)
      @declarations = Declarations.read_from_katana(rule.declarations)
    end
  end
end
