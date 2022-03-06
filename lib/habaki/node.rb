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

    # @param [Formatter::Base] format
    # @return [::String]
    def string(format = Formatter::Base.new)
      ""
    end

    # @return [::String]
    def to_s
      string(Formatter::Flat.new)
    end

    # read from low level Katana struct
    # @return [nil]
    def read_from_katana(low) end
  end

  class NodeArray < Array
    extend NodeReader

    # @param [Formatter::Base] format
    # @return [::String]
    def string(format = Formatter::Base.new)
      ""
    end

    def string_join(format, sep)
      map do |node| node.string(format) end.join(sep)
    end

    # @return [::String]
    def to_s
      string(Formatter::Flat.new)
    end

    # read from low level Katana struct
    # @return [nil]
    def read_from_katana(low) end
  end
end
