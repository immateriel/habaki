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

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      str = ""
      case @expressions.length
      when 0
        if @declaration
          str += "(#{@declaration.string(format)})"
        end
      when 1
        str += "(#{@operation == :not ? "not " : ""}" + @expressions[0].string(format) + ")"
      when 2
        str += "#{@expressions[0].string(format)} #{@operation} #{@expressions[1].string(format)}"
      end
      str
    end

    # @api private
    def read_from_katana(exp)
      @operation = exp.operation
      exp.expressions.each do |sub_exp|
        @expressions << SupportsExpression.read_from_katana(sub_exp)
      end
      @declaration = Declaration.read_from_katana(exp.declaration) if exp.declaration
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
    def string(format = Formatter::Base.new)
      "@supports #{@expression.string(format)} {\n#{@rules.string(format + 1)}\n}"
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
