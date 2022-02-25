module Habaki

  class Error < Node
    attr_accessor :line, :column, :message

    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
      self
    end
  end

  class Stylesheet < Node
    include RulesReader
    attr_accessor :rules, :errors

    def initialize
      @rules = Rules.new
      @errors = []
    end

    def self.parse(data)
      self.new.parse(data)
    end

    def parse(data)
      read(Katana.parse(data))
      self
    end

    # @param [Katana::Output] out
    def read(out)
      out.stylesheet.imports.each do |rul|
        @rules << ImportRule.read(rul)
      end

      out.stylesheet.rules.each do |rul|
        @rules << read_rule(rul)
      end

      out.errors.each do |err|
        @errors << Error.read(err)
      end
      self
    end

    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
