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
    def read(exp)
      @operation = exp.operation
      exp.expressions.each do |sub_exp|
        @expressions << SupportsExpression.read(sub_exp)
      end
      @declaration = Declaration.read(exp.declaration) if exp.declaration
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
    # @return [SupportExp]
    attr_accessor :expression
    # @return [Rules]
    attr_accessor :rules

    def initialize
      @rules = Rules.new
    end

    # @api private
    # @param [Katana::SupportsRule] rule
    # @return [void]
    def read(rule)
      @expression = SupportsExpression.read(rule.expression)
      @rules = Rules.read(rule.rules)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@supports #{@expression.string} {\n#{@rules.string(indent)}\n}"
    end
  end
end
