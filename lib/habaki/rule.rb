module Habaki
  # CSS style rule selectors + declarations
  class StyleRule < Node
    # @return [Array<Selector>]
    attr_accessor :selectors
    # @return [Array<Declaration>]
    attr_accessor :declarations

    def initialize
      @selectors = Selectors.new
      @declarations = Declarations.new
    end

    def read(rule)
      @selectors = Selectors.read(rule.selectors)
      @declarations = Declarations.read(rule.declarations)
      self
    end

    def string(indent = 0)
      "#{@selectors.string} {#{@declarations.string(indent)}#{" " * (indent > 0 ? indent - 1 : 0)}}"
    end
  end

  class MediaQueryExpression < Node
    attr_accessor :feature, :values

    def initialize
      @values = Values.new
    end

    def read(exp)
      @feature = exp.feature
      if exp.values
        @values = Values.read(exp.values)
      end
      self
    end

    def string(indent = 0)
      "(#{@feature}#{@values.length > 0 ? ": #{@values.string}" : ""})"
    end
  end

  class MediaQuery < Node
    attr_accessor :type, :restrictor, :expressions

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

    def read(med)
      @type = med.type
      @restrictor = med.restrictor
      med.expressions.each do |exp|
        @expressions << MediaQueryExpression.read(exp)
      end
      self
    end

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

  class Rules < Array
    extend NodeReader

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

    def read_rule(rul)
      case rul
      when Katana::ImportRule
        ImportRule.read(rul)
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

    def read(rules)
      rules.each do |rule|
        push read_rule(rule)
      end
      self
    end

    def string(indent = 0)
      str = " " * (indent > 0 ? indent - 1 : 0)
      str += map { |rule| rule.string(indent) }.join("\n")
      str
    end
  end

  class Medias < Array
    extend NodeReader

    def read(meds)
      meds.each do |med|
        push MediaQuery.read(med)
      end
      self
    end

    def string(indent = 0)
      map(&:string).join(",")
    end
  end

  # import rule @import
  class ImportRule < Node
    attr_accessor :href, :medias

    def initialize
      @medias = Medias.new
    end

    def read(rul)
      @href = rul.href
      @medias = Medias.read(rul.medias)
      self
    end

    def string(indent = 0)
      "@import \"#{@href}\" #{@medias.string};"
    end
  end

  # import rule @media
  class MediaRule < Node
    attr_accessor :medias, :rules

    def initialize
      @medias = Medias.new
      @rules = Rules.new
    end

    def match_type?(mediatype = "all")
      @medias.first&.match_type?(mediatype)
    end

    def read(rul)
      @medias = Medias.read(rul.medias)
      @rules = Rules.read(rul.rules)
      self
    end

    def string(indent = 0)
      "@media #{@medias.string} {\n#{@rules.string(indent + 1)}\n}"
    end
  end

  # font face rule @font-face
  class FontFaceRule < Node
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    def read(rule)
      @declarations = Declarations.read(rule.declarations)
      self
    end

    def string(indent = 0)
      "@font-face {#{@declarations.string(indent)}}"
    end
  end

  # page rule @page
  class PageRule < Node
    attr_accessor :declarations

    def initialize
      @declarations = Declarations.new
    end

    def read(rule)
      @declarations = Declarations.read(rule.declarations)
      self
    end

    def string(indent = 0)
      "@page {#{@declarations.string(indent)}}"
    end
  end

  # namespace rule @namespace
  # TODO implement QualifiedName namespace resolution
  class NamespaceRule < Node
    attr_accessor :prefix
    attr_accessor :uri

    def read(rule)
      @prefix = rule.prefix
      @uri = rule.uri
      self
    end

    def string(indent = 0)
      "@namespace #{@prefix.length > 0 ? "#{@prefix} " : ""}\"#{@uri}\";"
    end
  end

  class SupportsExp < Node
    attr_accessor :operation
    attr_accessor :expressions
    attr_accessor :declaration

    def initialize
      @expressions = []
    end

    def read(exp)
      @operation = exp.operation
      exp.expressions.each do |sub_exp|
        @expressions << SupportsExp.read(sub_exp)
      end
      @declaration = Declaration.read(exp.declaration) if exp.declaration
      self
    end

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

  class SupportsRule < Node
    attr_accessor :expression
    attr_accessor :rules

    def initialize
      @rules = Rules.new
    end

    def read(rul)
      @expression = SupportsExp.read(rul.expression)
      @rules = Rules.read(rul.rules)
      self
    end

    def string(indent = 0)
      "@supports #{@expression.string} {\n#{@rules.string(indent)}\n}"
    end
  end
end
