module Habaki
  # Rule for @charset
  class CharsetRule < Rule
    # @return [String]
    attr_accessor :encoding

    # @param [String] encoding
    def initialize(encoding = nil)
      @encoding
    end

    # @return [String]
    def string(indent = 0)
      "@charset \"#{@encoding}\";"
    end

    # @api private
    # @param [Katana::CharsetRule] rule
    # @return [void]
    def read_from_katana(rule)
      @encoding = rule.encoding
    end
  end
end
