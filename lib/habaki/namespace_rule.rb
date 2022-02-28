module Habaki
  # Rule for @namespace
  # TODO: implement QualifiedName namespace resolution
  class NamespaceRule < Rule
    # @return [String]
    attr_accessor :prefix
    # @return [String]
    attr_accessor :uri

    # @param [String] prefix
    # @param [String] uri
    def initialize(prefix = nil, uri = nil)
      @prefix = prefix
      @uri = uri
    end

    # @api private
    # @param [Katana::NamespaceRule] rule
    # @return [void]
    def read(rule)
      @prefix = rule.prefix
      @uri = rule.uri
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@namespace #{@prefix.length > 0 ? "#{@prefix} " : ""}\"#{@uri}\";"
    end
  end
end