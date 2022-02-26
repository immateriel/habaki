module Habaki
  # syntax error
  class Error < Node
    # @return [Integer]
    attr_accessor :line
    # @return [Integer]
    attr_accessor :column
    # @return [String]
    attr_accessor :message

    # @!visibility private
    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
      self
    end
  end

  # main structure
  class Stylesheet < Node
    # @return [Rules]
    attr_accessor :rules
    # @return [Array<Error>]
    attr_accessor :errors

    def initialize
      @rules = Rules.new
      @errors = []
    end

    # traverse all rules (including media & supports)
    def each_rule(&block)
      @rules.each do |rule|
        block.call rule
        if rule.rules
          rule.rules.each do |emb_rule|
            block.call emb_rule
          end
        end
      end
    end

    # remove all empty rules
    def compact!
      @rules.reject!{|rule| rule.declarations && rule.declarations.length == 0}
      @rules.each do |rule|
        if rule.rules
          rule.rules.reject!{|emb_rule| emb_rule.declarations && emb_rule.declarations.length == 0}
        end
      end
      @rules.reject!{|rule| rule.rules && rule.rules.length == 0}
    end

    # instanciate and parse from data
    # @param [String] data
    # @return [Stylesheet]
    def self.parse(data)
      stylesheet = self.new
      stylesheet.parse(data)
      stylesheet
    end

    # parse from file
    # @param [String] filename
    # @return [nil]
    def self.parse_file(filename)
      parse(File.read(filename))
    end

    # parse from data
    # @param [String] data
    # @return [nil]
    def parse(data)
      read(Katana.parse(data))
    end

    # parse from file
    # @param [String] filename
    # @return [nil]
    def parse_file(filename)
      parse(File.read(filename))
    end

    # @!visibility private
    # @param [Katana::Output] out
    def read(out)
      @rules.read(out.stylesheet.imports)
      @rules.read(out.stylesheet.rules)

      out.errors.each do |err|
        @errors << Error.read(err)
      end
    end

    # @!visibility private
    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
