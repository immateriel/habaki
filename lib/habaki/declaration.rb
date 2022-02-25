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

    # @!visibility private
    # @param [Katana::Declaration] decl
    def read(decl)
      @property = decl.property
      @important = decl.important
      @values = Values.read(decl.values)
    end

    # @!visibility private
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

    # find declaration with property
    # @param [String] property
    # @return [Declaration]
    def find_by_property(property)
      select { |decl| decl.property == property }.first
    end

    # remove declaration with property
    # @param [String] property
    # @return [nil]
    def remove_by_property(property)
      reject! { |decl| decl.property == property }
    end

    # add declaration
    # @param [String] property
    # @param [Value, Array<Value>] value
    # @return [nil]
    def add_by_property(property, value)
      decl = Habaki::Declaration.new(property)
      decl.values = Values.new([value].flatten)
      push decl
    end

    # @!visibility private
    # @param [Katana::Array] decls
    def read(decls)
      decls.each do |decl|
        push Declaration.read(decl)
      end
    end

    # @!visibility private
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
