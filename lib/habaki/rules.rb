module Habaki
  class Rules < NodeArray
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
    def add_by_selectors(selector_str)
      rule = StyleRule.new
      rule.selectors = Selectors.parse(selector_str)
      push rule
      rule
    end

    # rules matching with {Visitor::Element} enumerator
    # @param [Visitor::Element] element
    # @return [Enumerator<Rule>]
    def matching_rules(element)
      Enumerator.new do |rules|
        each do |rule|
          rules << rule if rule.match?(element)
        end
      end
    end

    # traverse rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @yieldparam [Rule] rule
    # @return [void]
    def each_matching_rule(element, &block)
      matching_rules(element).each do |rule|
        block.call rule
      end
    end

    # get rules matching with Visitor::Element
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def find_matching_rules(element)
      matching_rules(element).to_a
    end

    # traverse matching declarations for {Visitor::Element}
    # @param [String] property
    # @param [Visitor::Element] element
    # @yieldparam [Declaration] declaration
    # @return [void]
    def each_matching_declaration(property, element, &block)
      found = false
      cur_element = element
      while cur_element do
        each_matching_rule(cur_element) do |rule|
          decl = rule.declarations.find_by_property(property)
          found = false
          found = block.call decl if decl
        end
        break if found

        cur_element = cur_element.parent
      end
    end

    # @api private
    # @param [Katana::Array] rules
    # @return [void]
    def read(rules)
      rules.each do |rule|
        push read_rule(rule)
      end
    end

    # @api private
    def string(indent = 0)
      str = " " * (indent > 0 ? indent - 1 : 0)
      str += map { |rule| rule.string(indent) }.join("\n")
      str
    end

    private

    def read_rule(rul)
      case rul
      when Katana::ImportRule
        ImportRule.read(rul)
      when Katana::CharsetRule
        CharsetRule.read(rul)
      when Katana::MediaRule
        MediaRule.read(rul)
      when Katana::FontFaceRule
        FontFaceRule.read(rul)
      when Katana::PageRule
        PageRule.read(rul)
      when Katana::NamespaceRule
        NamespaceRule.read(rul)
      when Katana::StyleRule
        StyleRule.read(rul)
      when Katana::SupportsRule
        SupportsRule.read(rul)
      else
        raise "Unsupported rule #{rul.class}"
      end
    end
  end
end
