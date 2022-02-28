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

    # @api private
    # @param [Katana::QualifiedName] tag
    def read(tag)
      @local = tag.local
      @prefix = tag.prefix
    end

    # @api private
    def string(indent = 0)
      @prefix ? "#{@prefix}|#{@local}" : @local
    end
  end
end
