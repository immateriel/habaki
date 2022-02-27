module Habaki
  class Declaration < Node
    # @return [String]
    attr_accessor :property
    # @return [Values]
    attr_accessor :values
    # @return [Boolean]
    attr_accessor :important

    def initialize(property = nil, important = false)
      @property = property
      @important = important
      @values = Values.new
    end

    # shortcut to first value
    # @return [Value]
    def value
      @values.first
    end

    # @api private
    # @param [Katana::Declaration] decl
    # @return [void]
    def read(decl)
      @property = decl.property
      @important = decl.important
      @values = Values.read(decl.values)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "#{" " * indent}#{@property}: #{@values.string}#{important_string}"
    end

    private

    def important_string
      @important ? " !important" : ""
    end
  end

  # Array of {Declaration}
  class Declarations < Array
    extend NodeReader

    # parse inline declarations
    # @param [String] data
    # @return [Declarations]
    def self.parse(data)
      decls = self.new
      decls.parse(data)
      decls
    end

    # parse inline declarations
    # @param [String] data
    # @return [void]
    def parse(data)
      out = Katana.parse_inline(data)
      if out.declarations
        read(out.declarations)
      end
    end

    # find declaration with property
    # @param [String] property
    # @return [Declaration]
    def find_by_property(property)
      select { |decl| decl.property == property }.first
    end

    # remove declaration with property
    # @param [String] property
    # @return [void]
    def remove_by_property(property)
      reject! { |decl| decl.property == property }
    end

    # add declaration
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
