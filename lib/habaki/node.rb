module Habaki
  module NodeReader
    # read from low level struct
    def read(low)
      obj = self.new
      obj.read(low)
    end
  end

  class Node
    extend NodeReader

    def read(low) end

    def string(indent = 0) end

    def to_s
      string
    end
  end
end
