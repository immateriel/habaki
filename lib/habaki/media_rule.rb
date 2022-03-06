module Habaki
  class MediaQueryExpression < Node
    # @return [String]
    attr_accessor :feature
    # @return [Values]
    attr_accessor :values

    def initialize
      @values = Values.new
    end

    # @return [Value]
    def value
      @values.first
    end

    # @param [Visitor::Media] media
    # @return [Boolean]
    def media_match?(media)
      case @feature
      when "min-width"
        return true unless media.width
        media.width >= value.to_px
      when "max-width"
        return true unless media.width
        media.width <= value.to_px
      when "min-height"
        return true unless media.height
        media.height >= value.to_px
      when "max-height"
        return true unless media.height
        media.height <= value.to_px
      end
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "(#{@feature}#{@values.any? ? ": #{@values.string(format)}" : ""})"
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

    def media_match_type?(mediatype = "all")
      return true unless mediatype
      case @restrictor
      when :none, :only
        @type == mediatype || @type == "all" || !mediatype
      when :not
        @type != mediatype
      else
        false
      end
    end

    # @param [Visitor::Media] media
    def media_match?(media)
      return false unless media_match_type?(media.type)
      @expressions.each do |exp|
        return false unless exp.media_match?(media)
      end
      true
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      str = (@restrictor != :none ? @restrictor.to_s + " " : "") + (@type ? @type : "")
      if @expressions.any?
        @expressions.each do |exp|
          str += " and " if str != ""
          str += exp.string(format)
        end
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
    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      string_join(format, ",")
    end

    # @param [Visitor::Media] media
    # @return [Boolean]
    def media_match?(media)
      inject(false) { |result, q| result ||= q.media_match?(media) }
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

    # does rule media match ?
    # @param [Visitor::Media, String, NilClass] media use String (eg: "print") to check only media type, nil to match everything, or Visitor::Media for complex query
    # @return [Boolean]
    def media_match?(media)
      case media
      when ::String, NilClass
        @medias.media_match?(Visitor::Media.new(media))
      else
        @medias.media_match?(media)
      end
    end

    # @param [Formatter::Base] format
    # @return [String]
    def string(format = Formatter::Base.new)
      "@media #{@medias.string(format)} {\n#{@rules.string(format + 1)}\n}"
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
