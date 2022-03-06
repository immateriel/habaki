module Habaki
  # page rule @page
  class PageRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "@page {#{@declarations.string(format + 1)}}"
    end

    # @api private
    # @param [Katana::PageRule] rule
    # @return [void]
    def read_from_katana(rule)
      @declarations = Declarations.read_from_katana(rule.declarations)
    end
  end
end
