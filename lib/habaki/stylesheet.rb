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

    # rules matching with {Visitor::Element} enumerator
    # @param [Visitor::Element] element
    # @return [Enumerator<Rule>]
    def matching_rules(element)
      Enumerator.new do |matching_rules|
        each_rules do |rules|
          rules.each_matching_rule(element) do |matching_rule|
            matching_rules << matching_rule
          end
        end
      end
    end

    # traverse rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def each_matching_rule(element, &block)
      matching_rules(element).each do |matching_rule|
        block.call matching_rule
      end
    end

    # get rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def find_matching_rules(element)
      matching_rules(element).to_a
    end

    # traverse matching declarations for {Visitor::Element}
    # @param [String] property
    # @param [Visitor::Element] element
    # @return [Declaration, nil]
    def each_matching_declaration(property, element, &block)
      each_rules do |rules|
        rules.each_matching_declaration(property, element, &block)
      end
    end

    # does selector exists ?
    # @param [String] selector_str
    # @return [Boolean]
    def has_selector?(selector_str)
      each_rule do |rule|
        return true if rule.selectors && rule.selectors.map(&:to_s).include?(selector_str)
      end
      false
    end

    # find declarations from selector str
    # @param [String] selector_str
    # @return [Array<Declarations>]
    def find_declarations_by_selector(selector_str)
      results = []
      each_rule do |rule|
        results << rule.declarations if rule.selectors && rule.selectors.map(&:to_s).include?(selector_str)
      end
      results
    end

    # remove rules with no declaration
    def compact!
      @rules.reject! { |rule| rule.declarations&.empty? || false }
      @rules.each do |rule|
        if rule.rules
          rule.rules.reject! { |emb_rule| emb_rule.declarations&.empty? || false }
        end
      end
      @rules.reject! { |rule| rule.rules&.empty? || false }
    end

    # add rule by selectors string
    # @param [String] selector_str
    # @return [StyleRule]
    def add_by_selectors(selector_str)
      @rules.add_by_selectors(selector_str)
    end

    # instanciate and parse from data
    # @param [String] data
    # @return [Stylesheet]
    def self.parse(data)
      stylesheet = self.new
      stylesheet.parse!(data)
      stylesheet
    end

    # instanciate and parse from file
    # @param [String] filename
    # @return [Stylesheet]
    def self.parse_file(filename)
      parse(File.read(filename))
    end

    # parse from data and append to current stylesheet
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

      # keep reference to this stylesheet in each rule
      each_rule do |rule|
        rule.stylesheet = self
      end

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
