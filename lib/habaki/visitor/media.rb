module Habaki
  module Visitor
    # media query visitor
    class Media
      # eg "print", "screen"
      # @return [String]
      attr_accessor :type
      # width, in pixels
      # @return [Integer]
      attr_accessor :width
      # height, in pixels
      # @return [Integer]
      attr_accessor :height

      def initialize(type = "all", width = nil, height = nil)
        @type = type
        @width = width
        @height = height
      end
    end
  end
end