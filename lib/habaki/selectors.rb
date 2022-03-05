module Habaki
  # Array of {Selectors}
  class Selectors < NodeArray
    # parse selectors from string
    # @param [String] data
    # @return [Selectors]
    def self.parse(data)
      sels = self.new
      sels.parse!(data)
      sels
    end

    # parse selectors from string and append to current selectors
    # @param [String] data
    # @return [void]
    def parse!(data)
      return unless data

      out = Katana.parse_selectors(data)
      if out.selectors
        read_from_katana(out.selectors)
      end
    end

    # does one of theses selectors match {Visitor::Element} ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def element_match?(element)
      each do |selector|
        return true if selector.element_match?(element)
      end
      false
    end

    # @return [String]
    def string(indent = 0)
      map(&:string).join(",")
    end

    # @api private
    # @param [Katana::Array<Katana::Selector>] sels
    def read_from_katana(sels)
      sels.each do |sel|
        push Selector.read_from_katana(sel)
      end
    end
  end
end
