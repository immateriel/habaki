module Habaki
  # syntax error
  class Error < Node
    # @return [Integer]
    attr_accessor :line
    # @return [Integer]
    attr_accessor :column
    # @return [String]
    attr_accessor :message

    # @!visibility private
    def read(err)
      @line = err.first_line
      @column = err.first_column
      @message = err.message
      self
    end
  end

  # main structure
  class Stylesheet < Node
    # @return [Rules]
    attr_accessor :rules
    # @return [Array<Error>]
    attr_accessor :errors

    def initialize
      @rules = Rules.new
      @errors = []
    end

    # traverse each style matching mediatype
    def each_style(mediatype = "all", &block)
      @rules.font_faces.each do |style|
        block.call style
      end
      if mediatype == "print" || mediatype == "all"
        @rules.pages.each do |style|
          block.call style
        end
      end
      @rules.styles.each do |style|
        block.call style
      end
      @rules.medias.select{|media| media.match_type?(mediatype)}.each do |style|
        block.call style
      end
    end

    # instanciate and parse from data
    # @param [String] data
    # @return [Stylesheet]
    def self.parse(data)
      stylesheet = self.new
      stylesheet.parse(data)
      stylesheet
    end

    # parse from data
    # @param [String] data
    # @return [nil]
    def parse(data)
      read(Katana.parse(data))
    end

    # @!visibility private
    # @param [Katana::Output] out
    def read(out)
      @rules.read(out.stylesheet.imports)
      @rules.read(out.stylesheet.rules)

      out.errors.each do |err|
        @errors << Error.read(err)
      end
    end

    # @!visibility private
    def string(indent = 0)
      @rules.string(indent)
    end
  end
end
