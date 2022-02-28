module Habaki
  class Declaration < Node
    # @return [String]
    attr_accessor :property
    # @return [Values]
    attr_accessor :values
    # @return [Boolean]
    attr_accessor :important

    # @return [SourcePosition]
    attr_accessor :position

    def initialize(property = nil, important = false)
      @property = property
      @important = important
      @values = Values.new
    end

    # shortcut to first value
    # @return [Value]
    def value
      @values.first
    end

    # @api private
    # @param [Katana::Declaration] decl
    # @return [void]
    def read(decl)
      @property = decl.property
      @important = decl.important
      @values = Values.read(decl.values)
      @position = SourcePosition.new(decl.position.line, decl.position.column)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{" " * indent}#{@property}: #{@values.string}#{important_string}"
    end

    private

    def important_string
      @important ? " !important" : ""
    end
  end
end
