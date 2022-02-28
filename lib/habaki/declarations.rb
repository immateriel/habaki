module Habaki
  # Array of {Declaration}
  class Declarations < Array
    extend NodeReader

    # Parse inline declarations
    # @param [String] data
    # @return [Declarations]
    def self.parse(data)
      decls = self.new
      decls.parse!(data)
      decls
    end

    # Parse inline declarations and append to current declarations
    # @param [String] data
    # @return [void]
    def parse!(data)
      return unless data

      out = Katana.parse_inline(data)
      if out.declarations
        read(out.declarations)
      end
    end

    # Find declaration with property
    # @param [String] property
    # @return [Declaration]
    def find_by_property(property)
      select { |decl| decl.property == property }.first
    end

    # Remove declaration with property
    # @param [String] property
    # @return [void]
    def remove_by_property(property)
      reject! { |decl| decl.property == property }
    end

    # Add declaration
    # @param [String] property
    # @param [Value, Array<Value>] value
    # @return [void]
    def add_by_property(property, value)
      decl = Habaki::Declaration.new(property)
      decl.values = Values.new([value].flatten)
      push decl
    end

    # @api private
    # @param [Katana::Array<Katana::Declaration>] decls
    # @return [void]
    def read(decls)
      decls.each do |decl|
        push Declaration.read(decl)
      end
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      str = ""
      str += "\n" if indent > 0
      each { |decl|
        str += decl.string(indent)
        str += indent > 0 ? ";\n" : "; "
      }
      str
    end
  end
end
