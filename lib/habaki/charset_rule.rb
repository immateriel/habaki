module Habaki
  # Rule for @charset
  class CharsetRule < Rule
    # @return [String]
    attr_accessor :encoding

    # @param [String] encoding
    def initialize(encoding = nil)
      @encoding
    end

    # @api private
    # @param [Katana::CharsetRule] rule
    # @return [void]
    def read(rule)
      @encoding = rule.encoding
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@charset \"#{@encoding}\";"
    end
  end
end
