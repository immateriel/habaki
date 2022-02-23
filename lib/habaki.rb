require 'katana/katana'

module Habaki
  class Value
    attr_accessor :value, :unit

    def initialize
    end

    def parse(val)
      @value = val.value
      @unit = val.unit
      @raw = val.raw
      self
    end

    def to_s
      case @unit
      when :px, :pt, :ex, :em, :mm, :cm, :in, :pc, :rem, :ch, :deg, :rad, :turn, :vw, :vh, :vmin, :vmax, :dpi
        "#{value_i_or_f}#{@unit}"
      when :percentage
        "#{value_i_or_f}%"
      when :number
        value_i_or_f
      when :ident
        @value
      when :parser_hexcolor
        "##{@value}"
      when :parser_operator
        @value
      when :parser_function
        "#{@value.name}#{(@value.args ? @value.args.map{|a| Value.new.parse(a).to_s}.join(" ") : "")})"
      when :string
        "'#{@value}'"
      when :uri
        "url(#{@value.include?(" ") ? "\"#{@value}\"": @value})"
      when :unicode_range
        @value
      when :dimension # something is wrong ?
        0
      else
        raise "Unsupported value '#{@value}' #{@unit} (#{@raw})"
      end
    end

    private

    def value_i_or_f
      return 0 unless @value
      @value.round == @value ? @value.round : @value
    end
  end

  class Declaration
    attr_accessor :property, :values, :important
    attr_accessor :raw

    def initialize
      @values = []
    end

    def parse(decl)
      @property = decl.property
      @important = decl.important
      decl.values.each do |val|
        @values << Value.new.parse(val)
      end
      @raw = decl.raw
      self
    end

    def to_s
      v = @values.map(&:to_s).join(" ").gsub(/\s,/,",").gsub(/\s\/\s/,"/") # FIXME: improve that
      "#{@property}: #{v}#{@important ? " !important" : ""};"
    end
  end

  class SelectorData
    attr_accessor :attribute, :value, :argument, :selectors

    def initialize
      @selectors = []
    end

    def parse(dat)
      @attribute = dat.attribute&.local
      @value = dat.value
      @argument = dat.argument
      if dat.selectors
        dat.selectors.each do |sel|
          @selectors << Selector.new.parse(sel)
        end
      end
      self
    end
  end

  class Selector
    attr_accessor :match, :tag, :relation, :pseudo, :data, :history, :raw

    def initialize
    end

    def parse(sel)
      @match = sel.match
      @tag = sel.tag&.local
      @relation = sel.relation
      @pseudo = sel.pseudo
      @data = SelectorData.new.parse(sel.data)

      @history = Selector.new.parse(sel.tag_history) if sel.tag_history

      @raw = sel.to_s
      self
    end

    def to_s
      str = ""
      sel = self

      while sel do
        if sel.match.to_s.start_with?("attribute_")
          str += "[#{sel.data.attribute}"
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
          str += "\"#{sel.data.value}\"]" if sel.match != :attribute_set
        else
          case sel.match
          when :tag
            str += "#{sel.tag}"
          when :class
            str += ".#{sel.data.value}"
          when :id
            str += "##{sel.data.value}"
          when :attribute_contain
            str += "*="
          when :pseudo_class, :pseudo_page_class
            str += ":#{sel.data.value}"
            case sel.pseudo
            when :any, :not, :host, :host_context
              str += sel.data.selectors.map(&:to_s).join(",")
              str += ")"
            when :lang, :nth_child, :nth_last_child, :nth_of_type, :nth_last_of_type
              str += "#{sel.data.argument})"
            end
          when :pseudo_element
            str += "::#{sel.data.value}"
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

  class Rule
    attr_accessor :selectors, :declarations

    def initialize
      @selectors = []
      @declarations = []
    end

    def parse(rule)
      rule.selectors.each do |sel|
        @selectors << Selector.new.parse(sel)
      end
      rule.declarations.each do |decl|
        @declarations << Declaration.new.parse(decl)
      end
      self
    end

    def to_s
      @selectors.map(&:to_s).join(",") + " {" + @declarations.map(&:to_s).join(" ") + "}"
    end
  end

  class MediaQueryExpression
    attr_accessor :feature, :values

    def initialize
      @values = []
    end

    def parse(exp)
      @feature = exp.feature
      exp.values.each do |val|
        @values << Value.new.parse(val)
      end
      self
    end

    def to_s
      "#{@feature}: #{@values.map(&:to_s).join(" ")}"
    end
  end

  class MediaQuery
    attr_accessor :type, :restrictor, :expressions

    def initialize
      @expressions = []
    end

    def parse(med)
      @type = med.type
      @restrictor = med.restrictor
      med.expressions.each do |exp|
        @expressions << MediaQueryExpression.new.parse(exp)
      end
      self
    end

    # FIXME: to complete
    def to_s
      str = (@restrictor != :none ? @restrictor.to_s + " " : "") + @type
      if @expressions.length > 0
        str += " and ("
        @expressions.each do |exp|
          str += exp.to_s
        end
        str += ")"
      end
      str
    end
  end

  module Rules
    def parse_rule(rul)
      case rul
      when Katana::MediaRule
        MediaRule.new.parse(rul)
      when Katana::FontFaceRule
        FontFaceRule.new.parse(rul)
      when Katana::PageRule
        PageRule.new.parse(rul)
      when Katana::StyleRule
        Rule.new.parse(rul)
      else
        raise "Unsupported rule #{rul.class}"
      end
    end
  end

  class ImportRule
    attr_accessor :href, :medias
    def initialize
      @medias = []
    end

    def parse(rul)
      @href = rul.href
      rul.medias.each do |media|
        @medias << MediaQuery.new.parse(media)
      end
      self
    end

    def to_s
      "@import \"#{@href}\" " + @medias.map(&:to_s).join(",") + ";"
    end

  end

  class MediaRule
    include Rules
    attr_accessor :medias, :rules

    def initialize
      @rules = []
      @medias = []
    end

    def parse(rul)
      rul.medias.each do |media|
        @medias << MediaQuery.new.parse(media)
      end
      rul.rules.each do |rul|
        @rules << parse_rule(rul)
      end
      self
    end

    def to_s
      "@media " + @medias.map(&:to_s).join(",") + " {\n" + @rules.map(&:to_s).join("\n") + "\n}"
    end
  end

  class FontFaceRule
    attr_accessor :declarations

    def initialize
      @declarations = []
    end

    def parse(rule)
      rule.declarations.each do |decl|
        @declarations << Declaration.new.parse(decl)
      end
      self
    end

    def to_s
      "@font-face {" + @declarations.map(&:to_s).join(" ") + "}"
    end
  end

  class PageRule
    attr_accessor :declarations

    def initialize
      @declarations = []
    end

    def parse(rule)
      rule.declarations.each do |decl|
        @declarations << Declaration.new.parse(decl)
      end
      self
    end

    def to_s
      "@page {\n" + @declarations.map(&:to_s).join("\n") + "\n}"
    end
  end

  class Stylesheet
    include Rules
    attr_accessor :rules

    def initialize
      @rules = []
    end

    def parse(data)
      out = Katana.parse(data)

      out.stylesheet.imports.each do |rul|
        @rules << ImportRule.new.parse(rul)
      end

      out.stylesheet.rules.each do |rul|
        @rules << parse_rule(rul)
      end

      out.errors.each do |err|
        puts "ERR: #{err.first_line}:#{err.first_column} #{err.message}"
      end
      self
    end

    def to_s
      @rules.map(&:to_s).join("\n")
    end
  end
end
