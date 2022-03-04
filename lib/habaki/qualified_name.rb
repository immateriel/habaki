module Habaki
  # name with optional ns prefix
  class QualifiedName < Node
    attr_accessor :local, :prefix

    # @param [String] local
    # @param [String] prefix
    def initialize(local = nil, prefix = nil)
      @local = local
      @prefix = prefix
    end

    # @return [String]
    def string(indent = 0)
      @prefix ? "#{@prefix}|#{@local}" : @local
    end

    # @api private
    # @param [Katana::QualifiedName] tag
    def read_from_katana(tag)
      @local = tag.local
      @prefix = tag.prefix
    end
  end
end
