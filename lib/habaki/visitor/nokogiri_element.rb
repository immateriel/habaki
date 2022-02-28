module Habaki
  module Visitor
    class NokogiriElement < Element
      attr_accessor :element

      def initialize(element)
        @element = element
      end

      def tag_name
        @element.name
      end

      def class_name
        @element["class"]
      end

      def id_name
        @element["id"]
      end

      def attr(key)
        @element[key]
      end

      def text
        @element.text
      end

      def parent
        Visitor::NokogiriElement.new(@element.parent) if @element.respond_to?(:parent)
      end

      def previous
        Visitor::NokogiriElement.new(@element.previous_element) if @element.respond_to?(:previous_element) && @element.previous_element
      end

      def children
        @element.children.map do |child|
          child.is_a?(Nokogiri::XML::Element) ? Visitor::NokogiriElement.new(child) : nil
        end.compact
      end

      def traverse &block
        @element.traverse do |el|
          next unless el.is_a?(Nokogiri::XML::Element)
          block.call Visitor::NokogiriElement.new(el)
        end
      end

      def ==(other)
        @element == other.element
      end
    end
  end
end
