module Habaki
  class Declaration < Node
    # @return [String]
    attr_accessor :property
    # @return [Array<Value>]
    attr_accessor :values
    # @return [Boolean]
    attr_accessor :important

    def initialize(property = nil, important = false)
      @property = property
      @important = important
      @values = Values.new
    end

    def value
      @values.first
    end

    def read(decl)
      @property = decl.property
      @important = decl.important
      @values = Values.read(decl.values)
      self
    end

    def string(indent = 0)
      "#{" " * indent}#{@property}: #{@values.string}#{important_string}"
    end

    private

    def important_string
      @important ? " !important" : ""
    end
  end

  class Declarations < Array
    extend NodeReader

    def read(decls)
      decls.each do |decl|
        push Declaration.read(decl)
      end
      self
    end

    # find declaration with property
    # @param [String] property
    def find_by_property(property)
      select { |decl| decl.property == property }.first
    end

    # remove declaration with property
    # @param [String] property
    def remove_by_property(property)
      reject! { |decl| decl.property == property }
    end

    # add declaration
    # @param [String] property
    # @param [Value, Array<Value>] value
    def add_by_property(property, value)
      decl = Habaki::Declaration.new(property)
      decl.values = Values.new([value].flatten)
      push decl
    end

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
