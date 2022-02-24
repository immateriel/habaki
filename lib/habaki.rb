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

    def read(low)
    end

    def string(indent = 0)
    end

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
      when :dimension # something is wrong ?
        "0"
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
      each{|decl|
        str += decl.string(indent)
        str += indent > 0 ? "\n" : " "
      }
      str
    end
  end

  class Selector < Node
    # @return [Symbol]
    attr_accessor :match
    # @return [String]
    attr_accessor :tag
    # @return [Symbol]
    attr_accessor :relation
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

    # @return [Selector]
    attr_accessor :history

    def initialize
      @selectors = Selectors.new
    end

    def read(sel)
      @match = sel.match
      @tag = sel.tag&.local
      @relation = sel.relation
      @pseudo = sel.pseudo

      @attribute = sel.data.attribute&.local
      @value = sel.data.value
      @argument = sel.data.argument
      if sel.data.selectors
        sel.data.selectors.each do |dat_sel|
          @selectors << Selector.read(dat_sel)
        end
      end

      @history = Selector.read(sel.tag_history) if sel.tag_history
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
      @tag == name
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
        return false unless name == @attribute
        case @match
        when :attribute_exact
          val == @value
        when :attribute_begin
          val.start_with?(@value)
        else
          false
        end
      else
        false
      end
    end

    def string(indent = 0)
      str = ""
      sel = self

      while sel do
        if sel.attribute_selector?
          str += "[#{sel.attribute}"
          case sel.match
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
          end
          str += "\"#{sel.value}\"]" if sel.match != :attribute_set
        else
          case sel.match
          when :tag
            str += "#{sel.tag}"
          when :class
            str += ".#{sel.value}"
          when :id
            str += "##{sel.value}"
          when :attribute_contain
            str += "*="
          when :pseudo_class, :pseudo_page_class
            str += ":#{sel.value}"
            case sel.pseudo
            when :any, :not, :host, :host_context
              str += sel.selectors.map(&:string).join(",")
              str += ")"
            when :lang, :nth_child, :nth_last_child, :nth_of_type, :nth_last_of_type
              str += "#{sel.argument})"
            end
          when :pseudo_element
            str += "::#{sel.value}"
          end
        end

        break if sel.relation != :sub_selector || !sel.history
        sel = sel.history
      end

      case sel.relation
      when :descendant
        str = sel.history.to_s + " " + str
      when :child
        str = sel.history.to_s + " > " + str
      when :direct_adjacent
        str = sel.history.to_s + " + " + str
      when :indirect_adjacent
        str = sel.history.to_s + " ~ " + str
      when :shadow_pseudo
        str = sel.history.to_s + str
      end

      str
    end
  end

  class Selectors < Array
    def string(indent = 0)
      map(&:string).join(",")
    end
  end

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
      "#{@selectors.string} {#{@declarations.string(indent)}#{" "*(indent > 0 ? indent - 1 : 0)}}"
    end
  end

  class MediaQueryExpression < Node
    attr_accessor :feature, :values

    def initialize
      @values = Values.new
    end

    def read(exp)
      @feature = exp.feature
      exp.values.each do |val|
        @values << Value.read(val)
      end
      self
    end

    def string(indent = 0)
      "(#{@feature}: #{@values.string})"
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
      str = (@restrictor != :none ? @restrictor.to_s + " " : "") + @type
      if @expressions.length > 0
        @expressions.each do |exp|
          str += " and "
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
      when Katana::StyleRule
        StyleRule.read(rul)
      else
        raise "Unsupported rule #{rul.class}"
      end
    end
  end

  class Rules < Array
    def string(indent = 0)
      str = " "*(indent > 0 ? indent - 1 : 0)
      str += map{|rule| rule.string(indent)}.join("\n")
      str
    end
  end

  class Medias < Array
    def string(indent = 0)
      map(&:string).join(",")
    end
  end

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
      "@media #{@medias.string} {\n#{@rules.string(indent+1)}\n}"
    end
  end

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

      @errors = out.errors
      self
    end

    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
