module Habaki
  # page rule @page
  class PageRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @api private
    # @param [Katana::PageRule] rule
    # @return [void]
    def read(rule)
      @declarations = Declarations.read(rule.declarations)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@page {#{@declarations.string(indent)}}"
    end
  end
end
