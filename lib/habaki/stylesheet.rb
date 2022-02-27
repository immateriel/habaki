module Habaki
  # syntax error
  class Error < Node
    # @return [Integer]
    attr_accessor :line
    # @return [Integer]
    attr_accessor :column
    # @return [String]
    attr_accessor :message

    # @api private
    # @param [Katana::Error] err
    # @return [void]
    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
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

    # get rules matching with SelectorVisitor
    # @param [SelectorVisitor] element
    # @return [Array<Rule>]
    def matching_rules(element)
      matching_rules = []
      each_rule do |rule|
        matching_rules << rule if rule.matches(element).include?(element)
      end
      matching_rules
    end

    # find declaration for SelectorVisitor with inherit
    # @param [String] property
    # @param [SelectorVisitor] element
    # @return [Declaration, nil]
    def find_declaration(property, element)
      cur_element = element
      decls = []
      while cur_element do
        rules = matching_rules(cur_element)
        rules.each do |rule|
          decl = rule.declarations.find_by_property(property)
          decls << decl if decl && decl.value.data != "inherit"
        end
        break if decls.length > 0

        cur_element = cur_element.parent
      end

      # TODO: manage !important
      decls.last
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
    # @return [Stylesheet]
    def self.parse_file(filename)
      parse(File.read(filename))
    end

    # parse from data
    # @param [String] data
    # @return [void]
    def parse(data)
      read(Katana.parse(data))
    end

    # parse from file
    # @param [String] filename
    # @return [void]
    def parse_file(filename)
      parse(File.read(filename))
    end

    # @api private
    # @param [Katana::Output] out
    # @return [void]
    def read(out)
      @rules.read(out.stylesheet.imports)
      @rules.read(out.stylesheet.rules)

      out.errors.each do |err|
        @errors << Error.read(err)
      end
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
