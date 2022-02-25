module Habaki
  class Declaration < Node
    # @return [String]
    attr_accessor :property
    # @return [Array<Value>]
    attr_accessor :values
    # @return [Boolean]
    attr_accessor :important

    def initialize
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
