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

    # check validity
    # @return [Boolean]
    def check
      Habaki::FormalSyntax::Matcher.new(self).match?
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{format.declaration_prefix}#{@property}: #{@values.string(format)}#{important_string}"
    end

    # @api private
    # @param [Katana::Declaration] decl
    # @return [void]
    def read_from_katana(decl)
      @property = decl.property.downcase if decl.property
      @important = decl.important
      @values = Values.read_from_katana(decl.values)
      @position = SourcePosition.new(decl.position.line, decl.position.column)
    end

    private

    def important_string
      @important ? " !important" : ""
    end
  end
end
