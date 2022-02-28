module Habaki
  class SourcePosition
    # @return [Integer]
    attr_accessor :line
    # @return [Integer]
    attr_accessor :column

    def initialize(line = 0, column = 0)
      @line = line
      @column = column
    end
  end

  # syntax error
  class Error < Node
    # @return [SourcePosition]
    attr_accessor :position
    # @return [String]
    attr_accessor :message

    def initialize
      @position = SourcePosition.new
    end

    # @return [Integer]
    def line
      @position.line
    end

    # @return [Integer]
    def column
      @position.column
    end

    # @api private
    # @param [Katana::Error] err
    # @return [void]
    def read(err)
      @position = SourcePosition.new(err.first_line, err.first_column)
      @message = err.message
    end
  end
end
