require 'katana/katana'

module Habaki
  class Node
    # lower level Katana struct
    attr_accessor :low

    # read from low level struct
    def self.read(low)
      obj = self.new
      obj.low = low
      obj.read(low)
    end

    def read(low) end

    def string(indent = 0) end

    def to_s
      string
    end
  end

  class Value < Node
    # @return [String, Float]
    attr_accessor :value
    # @return [Symbol]
    attr_accessor :unit

    def read(val)
      @value = val.value
      @unit = val.unit
      @args = Values.new
      if @unit == :parser_function && @value.args
        @value.args.each do |a|
          @args << Value.read(a)
        end
      end
      self
    end

    def string(indent = 0)
      case @unit
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :deg, :rad, :turn,
        :vw, :vh, :vmin, :vmax, :dppx, :dpi, :dpcm, :fr
        "#{value_i_or_f}#{@unit}"
      when :percentage
        "#{value_i_or_f}%"
      when :number
        "#{value_i_or_f}"
      when :ident
        @value
      when :parser_hexcolor
        "##{@value}"
      when :parser_operator
        @value
      when :parser_function
        "#{@value.name}#{@args.string})"
      when :string
        "'#{@value}'"
      when :uri
        "url(#{@value.include?(" ") ? "\"#{@value}\"" : @value})"
      when :unicode_range
        @value
      when :dimension # something is wrong with dimension
        @value
      when :unknown
        @value
      else
        raise "Unsupported value '#{@value}' #{@unit}"
      end
    end

    private

    def value_i_or_f
      return 0 unless @value
      @value.round == @value ? @value.round : @value
    end
  end

  class Values < Array
    def string(indent = 0)
      map(&:string).join(" ").gsub(/\s,/, ",").gsub(/\s\/\s/, "/") # FIXME: improve that
    end
  end

  class Declaration < Node
    # @return [String]
    attr_accessor :property
    # @return [Array<Value>]
    attr_accessor :values
    # @return [Boolean]
    attr_accessor :important

    def initialize
      @values = Values.new
    end

    def read(decl)
      @property = decl.property
      @important = decl.important
      decl.values.each do |val|
        @values << Value.read(val)
      end
      self
    end

    def string(indent = 0)
      "#{" " * indent}#{@property}: #{@values.string}#{@important ? " !important" : ""};"
    end
  end

  class Declarations < Array
    def string(indent = 0)
      str = ""
      str += "\n" if indent > 0
      each { |decl|
        str += decl.string(indent)
        str += indent > 0 ? "\n" : " "
      }
      str
    end
  end

  # name with optionnal prefix
  class QualifiedName < Node
    attr_accessor :local, :prefix

    def read(tag)
      @local = tag.local
      @prefix = tag.prefix
      self
    end

    def string(indent = 0)
      @prefix ? "#{@prefix}|#{@local}" : @local
    end
  end

  class SubSelector < Node
    # @return [Symbol]
    attr_accessor :match
    # @return [String]
    attr_accessor :tag
    # @return [Symbol]
    attr_accessor :pseudo

    # @return [String]
    attr_accessor :attribute
    # @return [String]
    attr_accessor :value
    # @return [String]
    attr_accessor :argument
    # @return [Array<Selector>]
    attr_accessor :selectors

    def read(sel)
      @match = sel.match
      @tag = QualifiedName.read(sel.tag) if sel.tag
      @pseudo = sel.pseudo

      @attribute = QualifiedName.read(sel.data.attribute) if sel.data.attribute
      @value = sel.data.value
      @argument = sel.data.argument
      if sel.data.selectors
        sel.data.selectors.each do |dat_sel|
          @selectors << Selector.read(dat_sel)
        end
      end
      self
    end

    # is this selector on attribute ?
    # @return [Boolean]
    def attribute_selector?
      @match.to_s.start_with?("attribute_")
    end

    # tag match
    # @param [String] name
    # @return [Boolean]
    def tag_match?(name)
      return false unless @match == :tag
      @tag.local == name
    end

    # class match
    # @param [String] name
    # @return [Boolean]
    def class_match?(name)
      return false unless @match == :class
      @value == name
    end

    # id match
    # @param [String] name
    # @return [Boolean]
    def id_match?(name)
      return false unless @match == :id
      @value == name
    end

    # attribute match
    # TODO: finish
    # @param [String] name
    # @param [String] val
    # @return [Boolean]
    def attribute_match?(name, val)
      if attribute_selector?
        return false unless name == @attribute.local
        case @match
        when :attribute_exact
          val == @value
        when :attribute_begin
          val.start_with?(@value)
        when :attribute_contain
          val.include?(@value)
        else
          false
        end
      else
        false
      end
    end

    def string(indent = 0)
      str = ""

      if attribute_selector?
        str += "[#{@attribute.string}"
        case @match
        when :attribute_exact
          str += "="
        when :attribute_set
          str += "]"
        when :attribute_list
          str += "~="
        when :attribute_hyphen
          str += "|="
        when :attribute_begin
          str += "^="
        when :attribute_end
          str += "$="
        when :attribute_contain
          str += "*="
        end
        str += "\"#{@value}\"]" if @match != :attribute_set
      else
        case @match
        when :tag
          str += @tag.string
        when :class
          str += ".#{@value}"
        when :id
          str += "##{@value}"
        when :attribute_contain
          str += "*="
        when :pseudo_class, :pseudo_page_class
          str += ":#{@value}"
          case @pseudo
          when :any, :not, :host, :host_context
            str += @selectors.string
            str += ")"
          when :lang, :nth_child, :nth_last_child, :nth_of_type, :nth_last_of_type
            str += "#{@argument})"
          end
        when :pseudo_element
          str += "::#{@value}"
        end
      end
      str
    end
  end

  class SubSelectors < Array
    attr_accessor :relation

    def string(indent = 0)
      str = ""
      case @relation
      when :descendant
        str += " "
      when :child
        str += " > "
      when :direct_adjacent
        str += " + "
      when :indirect_adjacent
        str += " ~ "
      end
      each do |sub_sel|
        str += sub_sel.string
      end
      str
    end
  end

  # CSS selector
  class Selector < Node
    attr_accessor :sub_selectors

    def initialize
      @sub_selectors = []
    end

    def read(sel)
      @sub_selectors = rec_sub_sel(sel)
      self
    end

    def string(indent = 0)
      @sub_selectors.map(&:string).join("")
    end

    private

    # parse sub selectors recursively
    def rec_sub_sel(sel)
      sub_sels = []
      cur_sel = sel
      cur_sub_sel = SubSelectors.new
      while cur_sel do
        cur_sub_sel << SubSelector.read(cur_sel)
        break if cur_sel.relation != :sub_selector || !cur_sel.tag_history
        cur_sel = cur_sel.tag_history
      end

      sub_sels << cur_sub_sel
      cur_sub_sel.relation = cur_sel.relation if cur_sel.relation != :sub_selector

      if cur_sel.relation != :sub_selector
        sub_sels = rec_sub_sel(cur_sel.tag_history) + sub_sels
      end
      sub_sels
    end
  end

  class Selectors < Array
    def string(indent = 0)
      map(&:string).join(",")
    end
  end

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
      rule.selectors.each do |sel|
        @selectors << Selector.read(sel)
      end
      rule.declarations.each do |decl|
        @declarations << Declaration.read(decl)
      end
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
        exp.values.each do |val|
          @values << Value.read(val)
        end
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

  module RulesReader
    def read_rule(rul)
      case rul
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

  class Rules < Array
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

    def string(indent = 0)
      str = " " * (indent > 0 ? indent - 1 : 0)
      str += map { |rule| rule.string(indent) }.join("\n")
      str
    end
  end

  class Medias < Array
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
      rul.medias.each do |media|
        @medias << MediaQuery.read(media)
      end
      self
    end

    def string(indent = 0)
      "@import \"#{@href}\" #{@medias.string};"
    end
  end

  # import rule @media
  class MediaRule < Node
    include RulesReader
    attr_accessor :medias, :rules

    def initialize
      @medias = Medias.new
      @rules = Rules.new
    end

    def read(rul)
      rul.medias.each do |media|
        @medias << MediaQuery.read(media)
      end
      rul.rules.each do |rul|
        @rules << read_rule(rul)
      end
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
      rule.declarations.each do |decl|
        @declarations << Declaration.read(decl)
      end
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
      rule.declarations.each do |decl|
        @declarations << Declaration.read(decl)
      end
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
          str += "(#{@declaration.string.gsub(/;$/, "")})"
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
    include RulesReader
    attr_accessor :expression
    attr_accessor :rules

    def initialize
      @rules = Rules.new
    end

    def read(rul)
      @expression = SupportsExp.read(rul.expression)
      rul.rules.each do |sub_rul|
        @rules << read_rule(sub_rul)
      end
      self
    end

    def string(indent = 0)
      "@supports #{@expression.string} {\n#{@rules.string(indent)}\n}"
    end
  end

  class Error < Node
    attr_accessor :line, :column, :message

    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
      self
    end
  end

  class Stylesheet < Node
    include RulesReader
    attr_accessor :rules, :errors

    def initialize
      @rules = Rules.new
      @errors = []
    end

    def self.parse(data)
      self.new.parse(data)
    end

    def parse(data)
      read(Katana.parse(data))
      self
    end

    # @param [Katana::Output] out
    def read(out)
      out.stylesheet.imports.each do |rul|
        @rules << ImportRule.read(rul)
      end

      out.stylesheet.rules.each do |rul|
        @rules << read_rule(rul)
      end

      out.errors.each do |err|
        @errors << Error.read(err)
      end
      self
    end

    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
