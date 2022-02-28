module Habaki
  # syntax error
  class Error < Node
    # @return [Integer]
    attr_accessor :line
    # @return [Integer]
    attr_accessor :column
    # @return [String]
    attr_accessor :message

    # @api private
    # @param [Katana::Error] err
    # @return [void]
    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
    end
  end
end
