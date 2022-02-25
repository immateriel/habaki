module Habaki
  module NodeReader
    # read from low level struct
    def read(low)
      obj = self.new
      obj.read(low)
      obj
    end
  end

  class Node
    extend NodeReader

    # @return [nil]
    def read(low) end

    # @return [::String]
    def string(indent = 0)
      ""
    end

    # @return [::String]
    def to_s
      string
    end
  end
end
