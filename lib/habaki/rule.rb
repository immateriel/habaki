module Habaki
  # @abstract CSS rule
  class Rule < Node
    # @return [Array, nil]
    def selectors
      nil
    end

    # traverse selector if selectors
    # @yieldparam [Selector] selector
    def each_selector(&block)
      return unless selectors

      selectors.each do |decl|
        block.call decl
      end
    end

    # @return [Array, nil]
    def declarations
      nil
    end

    # traverse declarations if declarations
    # @yieldparam [Declaration] declaration
    def each_declaration(&block)
      return unless declarations

      declarations.each do |decl|
        block.call decl
      end
    end

    # @return [Array, nil]
    def rules
      nil
    end

    def match?(element)
      false
    end
  end
end
