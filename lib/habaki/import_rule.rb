module Habaki
  # Rule for @import
  class ImportRule < Rule
    # @return [String]
    attr_accessor :href
    # @return [MediaQueries]
    attr_accessor :medias

    # @param [String] href
    def initialize(href = nil)
      @href = href
      @medias = MediaQueries.new
    end

    # @return [Habaki::Stylesheet]
    def stylesheet(base_dir: "")
      Stylesheet.parse_file(base_dir+@href)
    end

    # @api private
    # @param [Katana::ImportRule] rule
    # @return [void]
    def read(rule)
      @href = rule.href
      @medias = MediaQueries.read(rule.medias)
    end

    # @api private
    # @return [String]
    def string(indent = 0)
      "@import \"#{@href}\" #{@medias.string};"
    end
  end
end
