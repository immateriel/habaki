module Habaki
  module NodeReader
    # read from low level Katana struct
    def read_from_katana(low)
      obj = self.new
      obj.read_from_katana(low)
      obj
    end
  end

  class Node
    extend NodeReader

    # @return [::String]
    def string(indent = 0)
      ""
    end

    # @return [::String]
    def to_s
      string
    end

    # read from low level Katana struct
    # @return [nil]
    def read_from_katana(low) end
  end

  class NodeArray < Array
    extend NodeReader

    # @return [::String]
    def string(indent = 0)
      ""
    end

    # @return [::String]
    def to_s
      string
    end

    # read from low level Katana struct
    # @return [nil]
    def read_from_katana(low) end
  end
end
