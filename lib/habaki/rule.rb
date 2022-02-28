module Habaki
  # @abstract CSS rule
  class Rule < Node
    # @return [Array, nil]
    def selectors
      nil
    end

    # @return [Array, nil]
    def declarations
      nil
    end

    # @return [Array, nil]
    def rules
      nil
    end

    # @return [Array]
    def matches(element)
      []
    end
  end
end
