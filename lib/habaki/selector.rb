module Habaki
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
end