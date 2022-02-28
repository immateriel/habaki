module Habaki
  class Rules < Array
    extend NodeReader

    # @return [CharsetRule, nil]
    def charset
      select { |rule| rule.is_a?(CharsetRule) }.first
    end

    # @return [Array<MediaRule>]
    def medias
      select { |rule| rule.is_a?(MediaRule) }
    end

    # @return [Array<SupportsRule>]
    def supports
      select { |rule| rule.is_a?(SupportsRule) }
    end

    # @return [Array<NamespaceRule>]
    def namespaces
      select { |rule| rule.is_a?(NamespaceRule) }
    end

    # @return [Array<FontFaceRule>]
    def font_faces
      select { |rule| rule.is_a?(FontFaceRule) }
    end

    # @return [Array<PageRule>]
    def pages
      select { |rule| rule.is_a?(PageRule) }
    end

    # @return [Array<StyleRule>]
    def styles
      select { |rule| rule.is_a?(StyleRule) }
    end

    # traverse rules matching with {Visitor::Element}
    # @param [Visitor::Element] element
    # @yieldparam [Rule] rule
    # @return [void]
    def each_matching_rule(element, &block)
      each do |rule|
        block.call rule if rule.match?(element)
      end
    end

    # get rules matching with Visitor::Element
    # @param [Visitor::Element] element
    # @return [Array<Rule>]
    def find_matching_rules(element)
      matching_rules = []
      each_matching_rule(element) do |rule|
        matching_rules << rule
      end
      matching_rules
    end

    # traverse matching declarations for {Visitor::Element} with inherit
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
          if decl && decl.value.data != "inherit"
            found = true
            block.call decl
          end
        end
        break if found

        cur_element = cur_element.parent
      end
    end

    # find matching declarations for {Visitor::Element} with inherit
    # @param [String] property
    # @param [Visitor::Element] element
    # @return [Array<Declaration>]
    def find_matching_declarations(property, element)
      decls = []
      each_declaration(property, element) do |decl|
        decls << decl
      end
      decls
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
