module Habaki
  class Rule < Node
    def selectors
      nil
    end

    def declarations
      nil
    end

    def rules
      nil
    end
  end

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

    # @!visibility private
    def read(rules)
      rules.each do |rule|
        push read_rule(rule)
      end
    end

    # @!visibility private
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

  # CSS style rule selectors + declarations
  class StyleRule < Rule
    # @return [Selectors]
    attr_accessor :selectors
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @selectors = Selectors.new
      @declarations = Declarations.new
    end

    # @!visibility private
    def read(rule)
      @selectors = Selectors.read(rule.selectors)
      @declarations = Declarations.read(rule.declarations)
    end

    # @!visibility private
    def string(indent = 0)
      "#{@selectors.string} {#{@declarations.string(indent)}#{" " * (indent > 0 ? indent - 1 : 0)}}"
    end
  end

  class MediaQueryExpression < Node
    attr_accessor :feature
    # @return [Values]
    attr_accessor :values

    def initialize
      @values = Values.new
    end

    # @!visibility private
    def read(exp)
      @feature = exp.feature
      if exp.values
        @values = Values.read(exp.values)
      end
    end

    # @!visibility private
    def string(indent = 0)
      "(#{@feature}#{@values.length > 0 ? ": #{@values.string}" : ""})"
    end
  end

  class MediaQuery < Node
    # @return [String]
    attr_accessor :type
    # @return [Symbol]
    attr_accessor :restrictor
    # @return [Array<MediaQueryExpression>]
    attr_accessor :expressions

    def initialize
      @expressions = []
    end

    def match_type?(mediatype = "all")
      case @restrictor
      when :none
        @type == mediatype || @type == "all"
      when :not
        @type != mediatype
      end
    end

    # @!visibility private
    def read(med)
      @type = med.type
      @restrictor = med.restrictor
      med.expressions.each do |exp|
        @expressions << MediaQueryExpression.read(exp)
      end
    end

    # @!visibility private
    def string(indent = 0)
      str = (@restrictor != :none ? @restrictor.to_s + " " : "") + (@type ? @type : "")
      if @expressions.length > 0
        @expressions.each do |exp|
          str += " and " if str != ""
          str += exp.string
        end
        str += ""
      end
      str
    end
  end

  # Array of {MediaQuery}
  class MediaQueries < Array
    extend NodeReader

    # @!visibility private
    def read(meds)
      meds.each do |med|
        push MediaQuery.read(med)
      end
    end

    # @!visibility private
    def string(indent = 0)
      map(&:string).join(",")
    end
  end

  # import rule @import
  class ImportRule < Rule
    # @return [String]
    attr_accessor :href
    # @return [MediaQueries]
    attr_accessor :medias

    def initialize
      @medias = MediaQueries.new
    end

    # @!visibility private
    def read(rul)
      @href = rul.href
      @medias = MediaQueries.read(rul.medias)
    end

    # @!visibility private
    def string(indent = 0)
      "@import \"#{@href}\" #{@medias.string};"
    end
  end

  # charset rule @charset
  class CharsetRule < Rule
    # @return [String]
    attr_accessor :encoding

    # @!visibility private
    def read(rul)
      @encoding = rul.encoding
    end

    # @!visibility private
    def string(indent = 0)
      "@charset \"#{@encoding}\";"
    end
  end

  # media rule @media
  class MediaRule < Rule
    # @return [MediaQueries]
    attr_accessor :medias
    # @return [Rules]
    attr_accessor :rules

    def initialize
      @medias = MediaQueries.new
      @rules = Rules.new
    end

    # does media match mediatype ?
    # @return [Boolean]
    def match_type?(mediatype = "all")
      @medias.first&.match_type?(mediatype)
    end

    # @!visibility private
    def read(rul)
      @medias = MediaQueries.read(rul.medias)
      @rules = Rules.read(rul.rules)
    end

    # @!visibility private
    def string(indent = 0)
      "@media #{@medias.string} {\n#{@rules.string(indent + 1)}\n}"
    end
  end

  # font face rule @font-face
  class FontFaceRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @!visibility private
    def read(rule)
      @declarations = Declarations.read(rule.declarations)
    end

    # @!visibility private
    def string(indent = 0)
      "@font-face {#{@declarations.string(indent)}}"
    end
  end

  # page rule @page
  class PageRule < Rule
    # @return [Declarations]
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    # @!visibility private
    def read(rule)
      @declarations = Declarations.read(rule.declarations)
    end

    # @!visibility private
    def string(indent = 0)
      "@page {#{@declarations.string(indent)}}"
    end
  end

  # namespace rule @namespace
  # TODO implement QualifiedName namespace resolution
  class NamespaceRule < Rule
    # @return [String]
    attr_accessor :prefix
    # @return [String]
    attr_accessor :uri

    # @!visibility private
    def read(rule)
      @prefix = rule.prefix
      @uri = rule.uri
    end

    # @!visibility private
    def string(indent = 0)
      "@namespace #{@prefix.length > 0 ? "#{@prefix} " : ""}\"#{@uri}\";"
    end
  end

  class SupportsExpression < Node
    # @return [Symbol]
    attr_accessor :operation
    # @return [Array<SupportsExpression>]
    attr_accessor :expressions
    # @return [Declaration]
    attr_accessor :declaration

    def initialize
      @expressions = []
    end

    # @!visibility private
    def read(exp)
      @operation = exp.operation
      exp.expressions.each do |sub_exp|
        @expressions << SupportsExpression.read(sub_exp)
      end
      @declaration = Declaration.read(exp.declaration) if exp.declaration
    end

    # @!visibility private
    def string(indent = 0)
      str = ""
      case @expressions.length
      when 0
        if @declaration
          str += "(#{@declaration.string})"
        end
      when 1
        str += "(#{@operation == :not ? "not " : ""}" + @expressions[0].string + ")"
      when 2
        str += "#{@expressions[0].string} #{@operation} #{@expressions[1].string}"
      end
      str
    end
  end

  class SupportsRule < Rule
    # @return [SupportExp]
    attr_accessor :expression
    # @return [Rules]
    attr_accessor :rules

    def initialize
      @rules = Rules.new
    end

    # @!visibility private
    def read(rul)
      @expression = SupportsExpression.read(rul.expression)
      @rules = Rules.read(rul.rules)
    end

    # @!visibility private
    def string(indent = 0)
      "@supports #{@expression.string} {\n#{@rules.string(indent)}\n}"
    end
  end
end
