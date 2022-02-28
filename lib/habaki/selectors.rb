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

    # select elements for this selector
    # @param [Visitor::Element] root
    # @return [Array<Visitor::Element>]
    def matches(root)
      flat_map{|selector| selector.matches(root)}.uniq
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
