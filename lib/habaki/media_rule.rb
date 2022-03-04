module Habaki
  class MediaQueryExpression < Node
    attr_accessor :feature
    # @return [Values]
    attr_accessor :values

    def initialize
      @values = Values.new
    end

    # @api private
    # @param [Katana::MediaQueryExpression] exp
    # @return [void]
    def read_from_katana(exp)
      @feature = exp.feature
      if exp.values
        @values = Values.read_from_katana(exp.values)
      end
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "(#{@feature}#{@values.any? ? ": #{@values.string}" : ""})"
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

    # @return [String]
    def string(indent = 0)
      str = (@restrictor != :none ? @restrictor.to_s + " " : "") + (@type ? @type : "")
      if @expressions.any?
        @expressions.each do |exp|
          str += " and " if str != ""
          str += exp.string
        end
        str += ""
      end
      str
    end

    # @api private
    # @param [Katana::MediaQuery] med
    # @return [void]
    def read_from_katana(med)
      @type = med.type
      @restrictor = med.restrictor
      med.expressions.each do |exp|
        @expressions << MediaQueryExpression.read_from_katana(exp)
      end
    end
  end

  # Array of {MediaQuery}
  class MediaQueries < NodeArray
    # @return [String]
    def string(indent = 0)
      map(&:string).join(",")
    end

    # @api private
    # @param [Katana::Array<Katana::MediaQuery>] meds
    # @return [void]
    def read_from_katana(meds)
      meds.each do |med|
        push MediaQuery.read_from_katana(med)
      end
    end
  end

  # Rule for @media
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

    # @return [String]
    def string(indent = 0)
      "@media #{@medias.string} {\n#{@rules.string(indent + 1)}\n}"
    end

    # @api private
    # @param [Katana::MediaRule] rule
    # @return [void]
    def read_from_katana(rule)
      @medias = MediaQueries.read_from_katana(rule.medias)
      @rules = Rules.read_from_katana(rule.rules)
    end
  end
end
