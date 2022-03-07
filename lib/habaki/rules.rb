module Habaki
  # selector matcher helper
  module SelectorMatcher
    # traverse rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @yieldparam [Rule] rule
    # @yieldparam [Selector] selector
    # @yieldparam [Specificity] specificity
    # @return [void]
    def each_match(element, *args, &block)
      each_rule(*args) do |rule|
        rule.each_selector do |selector|
          specificity = Specificity.new
          if selector.element_match?(element, specificity)
            block.call rule, selector, specificity
          end
        end
      end
    end

    # traverse rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @yieldparam [Rule] rule
    # @return [void]
    def each_matching_rule(element, *args, &block)
      find_matching_rules(element, *args).each do |rule|
        block.call rule
      end
    end

    # rules matching with {Visitor::Element} ordered by specificity
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def find_matching_rules(element, *args)
      results = []
      each_match(element, *args) do |rule, selector, specificity|
        results << [specificity.value, rule]
      end
      results.sort! { |a, b| a.first <=> b.first }
      results.map(&:last)
    end

    # get cascaded declarations results for {Visitor::Element}
    # @param [Visitor::Element] element
    # @return [Declarations]
    def find_matching_declarations(element, *args)
      declarations = Declarations.new
      each_matching_rule(element, *args) do |rule|
        rule.each_declaration do |decl|
          declarations.replace_important(decl)
        end
      end
      declarations
    end
  end

  class Rules < NodeArray
    include SelectorMatcher

    # @param [Class<Rule>] klass
    # @return [Enumerator<Rule>]
    def enum_with_class(klass)
      Enumerator.new do |rules|
        each do |rule|
          rules << rule if rule.is_a?(klass)
        end
      end
    end

    # @return [CharsetRule, nil]
    def charset
      enum_with_class(CharsetRule).first
    end

    # @return [Enumerator<MediaRule>]
    def medias
      enum_with_class(MediaRule)
    end

    # @return [Enumerator<SupportsRule>]
    def supports
      enum_with_class(SupportsRule)
    end

    # @return [Enumerator<NamespaceRule>]
    def namespaces
      enum_with_class(NamespaceRule)
    end

    # @return [Enumerator<FontFaceRule>]
    def font_faces
      enum_with_class(FontFaceRule)
    end

    # @return [Enumerator<PageRule>]
    def pages
      enum_with_class(PageRule)
    end

    # @return [Enumerator<StyleRule>]
    def styles
      enum_with_class(StyleRule)
    end

    # add rule by selectors string
    # @param [String] selector_str
    # @return [StyleRule]
    def add_by_selector(selector_str)
      rule = StyleRule.new
      rule.selectors = Selectors.parse(selector_str)
      push rule
      rule
    end

    # find rules from selector str
    # @param [String] selector_str
    # @return [Array<Rule>]
    def find_by_selector(selector_str)
      results = []
      each do |rule|
        rule.each_selector do |selector|
          results << rule if selector_str == selector.to_s
        end
      end
      results
    end

    def each_rule(&block)
      each &block
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "#{format.rules_prefix}#{string_join(format, format.rules_join)}"
    end

    # @api private
    # @param [Katana::Array] rules
    # @return [void]
    def read_from_katana(rules)
      rules.each do |rule|
        push read_rule(rule)
      end
    end

    private

    def read_rule(rul)
      case rul
      when Katana::ImportRule
        ImportRule.read_from_katana(rul)
      when Katana::CharsetRule
        CharsetRule.read_from_katana(rul)
      when Katana::MediaRule
        MediaRule.read_from_katana(rul)
      when Katana::FontFaceRule
        FontFaceRule.read_from_katana(rul)
      when Katana::PageRule
        PageRule.read_from_katana(rul)
      when Katana::NamespaceRule
        NamespaceRule.read_from_katana(rul)
      when Katana::StyleRule
        StyleRule.read_from_katana(rul)
      when Katana::SupportsRule
        SupportsRule.read_from_katana(rul)
      else
        raise "Unsupported rule #{rul.class}"
      end
    end
  end
end
