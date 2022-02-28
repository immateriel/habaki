module Habaki
  module Visitor
    # @abstract CSS selector element visitor
    class Element
      # element tag name
      # @return [String]
      def tag_name
      end

      # element class name
      # @return [String]
      def class_name
      end

      # element id name
      # @return [String]
      def id_name
      end

      # element attribute
      # @param [String] key
      # @return [String]
      def attr(key) end

      # inner text
      # @return [String]
      def text
      end

      # element parent
      # @return [Visitor::Element]
      def parent
      end

      # element previous
      # @return [Visitor::Element]
      def previous
      end

      # @return [Array<Visitor::Element>]
      def children
        []
      end

      # traverse elements
      def traverse &block
      end
    end
  end
end
