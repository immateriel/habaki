module Habaki
  # main structure
  class Stylesheet < Node
    include SelectorMatcher

    # @return [Rules]
    attr_accessor :rules
    # @return [Array<Error>]
    attr_accessor :errors

    def initialize
      @rules = Rules.new
      @errors = []
    end

    # traverse rules
    # @param [Visitor::Media, String, NilClass] media
    # @yieldparam [Rules] rules
    # @return [void]
    def each_rules(media = nil, &block)
      block.call @rules
      @rules.each do |rule|
        next unless rule.rules
        next if rule.is_a?(MediaRule) && !rule.media_match?(media)
        block.call rule.rules
      end
    end

    # traverse all rules (including all media & supports)
    # @param [Visitor::Media, String, NilClass] media
    # @yieldparam [Rule] rule
    # @return [void]
    def each_rule(media = nil, &block)
      each_rules(media) do |rules|
        rules.each do |rule|
          block.call rule
        end
      end
    end

    # does selector exists ?
    # @param [String] selector_str
    # @param [Visitor::Media, String, NilClass] media
    # @return [Boolean]
    def has_selector?(selector_str, media = nil)
      each_rule do |rule|
        rule.each_selector do |selector|
          return true if selector_str == selector.to_s
        end
      end
      false
    end

    # find rule from selector str
    # @param [String] selector_str
    # @param [Visitor::Media, String, NilClass] media
    # @return [Array<Rule>]
    def find_by_selector(selector_str, media = nil)
      results = []
      each_rule(media) do |rule|
        rule.each_selector do |selector|
          results << rule if selector_str == selector.to_s
        end
      end
      results
    end

    # find declarations from selector str
    # @param [String] selector_str
    # @param [Visitor::Media, String, NilClass] media
    # @return [Array<Declarations>]
    def find_declarations_by_selector(selector_str, media = nil)
      results = []
      each_rule(media) do |rule|
        next unless rule.selectors
        results << rule.declarations if rule.selectors.map(&:to_s).include?(selector_str)
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

      read_from_katana(Katana.parse(data))
    end

    # parse from file and append to current stylesheet
    # @param [String] filename
    # @return [void]
    def parse_file!(filename)
      parse(File.read(filename))
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      @rules.string(format)
    end

    # @api private
    # @param [Katana::Output] out
    # @return [void]
    def read_from_katana(out)
      @rules.read_from_katana(out.stylesheet.imports)
      @rules.read_from_katana(out.stylesheet.rules)

      # keep reference to this stylesheet in each rule
      each_rule do |rule|
        rule.stylesheet = self
      end

      out.errors.each do |err|
        @errors << Error.read_from_katana(err)
      end
    end
  end

  # group of stylesheets to match through multiple {Stylesheet}
  class Stylesheets < Array
    include SelectorMatcher

    def each_rule(media = nil, &block)
      each do |stylesheet|
        stylesheet.each_rule(media, &block)
      end
    end
  end
end
