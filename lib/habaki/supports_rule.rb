module Habaki
  class SupportsExpression < Node
    # @return [Symbol]
    attr_accessor :operation
    # @return [Array<SupportsExpression>]
    attr_accessor :expressions
    # @return [Declaration]
    attr_accessor :declaration

    def initialize
      @expressions = []
    end

    # @api private
    def read_from_katana(exp)
      @operation = exp.operation
      exp.expressions.each do |sub_exp|
        @expressions << SupportsExpression.read_from_katana(sub_exp)
      end
      @declaration = Declaration.read_from_katana(exp.declaration) if exp.declaration
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      str = ""
      case @expressions.length
      when 0
        if @declaration
          str += "(#{@declaration.string})"
        end
      when 1
        str += "(#{@operation == :not ? "not " : ""}" + @expressions[0].string + ")"
      when 2
        str += "#{@expressions[0].string} #{@operation} #{@expressions[1].string}"
      end
      str
    end
  end

  # supports rule @supports
  class SupportsRule < Rule
    # @return [SupportsExpression]
    attr_accessor :expression
    # @return [Rules]
    attr_accessor :rules

    def initialize
      @rules = Rules.new
    end

    # @return [String]
    def string(indent = 0)
      "@supports #{@expression.string} {\n#{@rules.string(indent)}\n}"
    end

    # @api private
    # @param [Katana::SupportsRule] rule
    # @return [void]
    def read_from_katana(rule)
      @expression = SupportsExpression.read_from_katana(rule.expression)
      @rules = Rules.read_from_katana(rule.rules)
    end
  end
end
