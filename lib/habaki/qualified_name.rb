module Habaki
  # name with optional ns prefix
  class QualifiedName < Node
    # @return [String]
    attr_accessor :local
    # @return [String]
    attr_accessor :prefix

    # @param [String] local
    # @param [String] prefix
    def initialize(local = nil, prefix = nil)
      @local = local
      @prefix = prefix
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
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
