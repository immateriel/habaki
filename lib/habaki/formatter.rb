module Habaki
  # output formatting
  module Formatter
    class Base
      # @return [Integer]
      attr_accessor :level

      def initialize(level = 0)
        @level = level
      end

      # @return [String]
      def declaration_prefix
        ""
      end

      # @return [String]
      def declarations_prefix
        ""
      end

      # @return [String]
      def declarations_join
        ""
      end

      # @return [String]
      def declarations_suffix
        ""
      end

      # @return [String]
      def rules_prefix
        ""
      end

      # @return [String]
      def rules_join
        ""
      end

      # @return [String]
      def quote
        "\""
      end

      # @return [self]
      def +(num)
        self.class.new(@level + num)
      end
    end

    # default flat formatting
    class Flat < Base
      # @return [String]
      def declarations_join
        " "
      end

      # @return [String]
      def rules_join
        "\n"
      end
    end

    # indented formatting
    class Indented < Base
      # @return [String]
      def declaration_prefix
        " " * @level
      end

      # @return [String]
      def declarations_join
        "\n"
      end

      # @return [String]
      def declarations_prefix
        "\n"
      end

      # @return [String]
      def declarations_suffix
        "\n"
      end

      # @return [String]
      def rules_prefix
        " " * @level
      end

      # @return [String]
      def rules_join
        "\n\n"
      end
    end
  end
end