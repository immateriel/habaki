module Habaki
  class Node
    # lower level Katana struct
    attr_accessor :low

    # read from low level struct
    def self.read(low)
      obj = self.new
      obj.low = low
      obj.read(low)
    end

    def read(low) end

    def string(indent = 0) end

    def to_s
      string
    end
  end
end
