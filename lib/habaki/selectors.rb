module Habaki
  # Array of {Selectors}
  class Selectors < Array
    extend NodeReader

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
        read(out.selectors)
      end
    end

    # does element match with on of these selectors ?
    # @param [Visitor::Element] element
    # @return [Boolean]
    def match?(element)
      each do |selector|
        return true if selector.match?(element)
      end
      false
    end

    # @api private
    # @param [Katana::Array<Katana::Selector>] sels
    def read(sels)
      sels.each do |sel|
        push Selector.read(sel)
      end
    end

    # @api private
    def string(indent = 0)
      map(&:string).join(",")
    end
  end
end
