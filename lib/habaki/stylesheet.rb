module Habaki
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

    # traverse rules
    # @yieldparam [Rules] rules
    # @return [void]
    def each_rules(&block)
      block.call @rules
      @rules.each do |rule|
        block.call rule.rules if rule.rules
      end
    end

    # traverse all rules (including all media & supports)
    # TODO: add media query / supports query option
    # @yieldparam [Rule] rules
    # @return [void]
    def each_rule(&block)
      each_rules do |rules|
        rules.each do |rule|
          block.call rule
        end
      end
    end

    # get rules matching with Visitor::Element
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def find_matching_rules(element)
      matching_rules = []
      each_rules do |rules|
        rules.each_matching_rule(element) do |matching_rule|
          matching_rules << matching_rule
        end
      end
      matching_rules
    end

    # traverse matching declarations for Visitor::Element
    # @param [String] property
    # @param [Visitor::Element] element
    # @return [Declaration, nil]
    def each_matching_declaration(property, element, &block)
      each_rules do |rules|
        rules.each_matching_declaration(property, element, &block)
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
      stylesheet.parse!(data)
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
    def parse!(data)
      return unless data

      read(Katana.parse(data))
    end

    # parse from file and append to current stylesheet
    # @param [String] filename
    # @return [void]
    def parse_file!(filename)
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
