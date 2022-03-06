module Habaki
  # Rule for @charset
  class CharsetRule < Rule
    # @return [String]
    attr_accessor :encoding

    # @param [String] encoding
    def initialize(encoding = nil)
      @encoding
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "@charset #{format.quote}#{@encoding}#{format.quote};"
    end

    # @api private
    # @param [Katana::CharsetRule] rule
    # @return [void]
    def read_from_katana(rule)
      @encoding = rule.encoding
    end
  end
end
