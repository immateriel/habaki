require 'strscan'
require 'yaml'

module Habaki
  # property pattern matching
  module FormalSyntax
    class Node
      attr_accessor :parent
      attr_accessor :children
      attr_accessor :type
      attr_accessor :value
      attr_accessor :occurence

      attr_accessor :orig

      def initialize(type = nil, value = nil, children = [], occurence = 1..1)
        @type = type
        @value = value
        @children = children
        @occurence = occurence
      end

      def push_children(child)
        child.parent = self
        @children << child
      end

      def traverse(&block)
        block.call self
        @children.each do |child|
          child.traverse &block
        end
      end

      def occurence_from_children!
        case @type
        when :and
          occ_min = 0
          occ_max = 0
          @children.each do |child|
            occ_min += child.occurence.begin
            occ_max += child.occurence.end
          end
          @occurence = Range.new(occ_min, occ_max)
        when :or_and
          @occurence = Range.new(1, @children.length)
        end
      end

      def n
        Float::INFINITY
      end

      def to_s
        str = ""
        case @type
        when :and
          str += "[#{@children.map(&:to_s).join(" ")}]"
        when :or
          str += "[#{@children.map(&:to_s).join(" | ")}]"
        when :or_and
          str += "[#{@children.map(&:to_s).join(" || ")}]"
        when :function
          str += "#{@value}(#{@children.map(&:to_s).join(" ")})"
        when :number
          str += @value.to_s
        when :token
          str += @value
        when :ref
          str += "'#{@value}'"
        when :type
          str += "<#{@value}>"
        else
          str += @value
        end

        case @occurence.begin
        when 0
          case @occurence.end
          when 1
            str += "?"
          when n
            str += "*"
          end
        when 1
          case @occurence.end
          when 1
          when n
            str += "+"
          else
            str += "{#{@occurence.begin},#{@occurence.end}}"
          end
        end

        str
      end
    end

    class FormalSyntaxError < StandardError
    end

    # format syntax tree parser
    class Tree
      attr_accessor :properties

      def initialize
      end

      def parse_all(data)
        @properties = {}
        data.each do |k, v|
          begin
            @properties[k] = Tree.parse(v)
          rescue FormalSyntaxError => e
            # STDERR.puts("#{k}: #{e}")
          end
        end
        #flatten!
        self
      end

      def self.tree
        @@tree ||= self.new.parse_all(Tree.tree_data)
      end

      def self.tree_data
        @@tree_data ||= YAML.load_file(File.join(File.dirname(__FILE__), '../../data/formal_syntax.yml')).freeze
      end

      def property(prop)
        @properties[prop]
      end

      def flatten!
        @properties.each do |prop, v|
          next unless v.children.length == 1
          child = v.children.first
          next unless child.occurence != (1..1)
          v.children = child.children
          v.type = child.type
          v.value = child.value
        end
      end

      def debug
        @properties.each do |k, root|
          if root.to_s != "[#{root.orig}]"
            puts "DIFF #{k}: "
            puts " [#{root.orig}]"
            puts " #{root}"
          end
        end
      end

      def expanded(property)
        node = @properties[property].dup
        node.traverse do |child|
          if child.type == :ref
            parent = child.parent
            idx = parent.children.index(child)
            parent.children[idx] = @properties[child.value]
          end
        end
        node
      end

      def self.n
        Float::INFINITY
      end

      # formal syntax parser
      def self.parse(str)
        current_node = Node.new(:and)
        current_node.orig = str
        scanner = StringScanner.new(str.gsub("∞", "N"))

        until scanner.eos?
          case
          when scanner.scan(/\[/)
            prev_node = current_node
            current_node = Node.new(:and)
            current_node.parent = prev_node
          when scanner.scan(/<([a-zA-Z0-9-]+)\(/)
            prev_node = current_node
            current_node = Node.new(:function_ref, scanner[1])
            current_node.parent = prev_node
          when scanner.scan(/([a-zA-Z0-9-]+)\(/)
            prev_node = current_node
            current_node = Node.new(:function, scanner[1])
            current_node.parent = prev_node
          when scanner.scan(/\?/)
            prev_node = current_node.children.last
            prev_node.occurence = 0..1
          when scanner.scan(/\*/)
            prev_node = current_node.children.last
            prev_node.occurence = 0..n
          when scanner.scan(/\+/)
            prev_node = current_node.children.last
            prev_node.occurence = 1..n
          when scanner.scan(/\!/)
            # at least one required
            prev_node = current_node.children.last
            prev_node.occurence = 1..n
          when scanner.scan(/\#/)
            # one or more comma separated
            prev_node = current_node.children.last
            prev_node.push_children(Node.new(:token, ","))
            prev_node.occurence = 1..n
          when scanner.scan(/\{(\d)\}/)
            prev_node = current_node.children.last
            prev_node.occurence = (scanner[1].to_i)..(scanner[1].to_i)
          when scanner.scan(/\{(\d),(\d)\}/)
            prev_node = current_node.children.last
            prev_node.occurence = (scanner[1].to_i)..(scanner[2].to_i)
          when scanner.scan(/\]/)
            current_node.occurence_from_children!
            if current_node.parent
              prev_node = current_node
              current_node = current_node.parent
              current_node.push_children prev_node
            else
              raise FormalSyntaxError, "Formal syntax problem: #{current_node}"
            end
          when scanner.scan(/\)>?/)
            if current_node.parent
              prev_node = current_node
              current_node = current_node.parent
              current_node.push_children prev_node
            else
              raise FormalSyntaxError, "Formal syntax problem: #{current_node}"
            end
          when scanner.scan(/\s?(\/|,|:|;|%)\s?/)
            current_node.push_children Node.new(:token, scanner[1])
          when scanner.scan(/<([a-zA-Z0-9-]+)(\s\[\d,N?\d*\])?>/)
            current_node.push_children Node.new(:type, scanner[1])
          when scanner.scan(/([a-zA-Z-]+)/)
            current_node.push_children Node.new(:ident, scanner[1]) #if scanner[1] != "inherit"
          when scanner.scan(/([0-9]+)/)
            current_node.push_children Node.new(:number, scanner[1].to_i)
          when scanner.scan(/<?'([a-zA-Z-]+)'>?/)
            current_node.push_children Node.new(:ref, scanner[1])
          when scanner.scan(/'(..?)'/)
            current_node.push_children Node.new(:token, scanner[1])
          when scanner.scan(/\|\|/)
            current_node.type = :or_and
          when scanner.scan(/\|/)
            current_node.type = :or
          when scanner.scan(/\&\&/)
            current_node.type = :and
          else
            result = scanner.scan(/.+/)
            raise FormalSyntaxError, "Cannot parse formal syntax: #{result}"
          end
          scanner.scan(/\s+/)
        end
        current_node.occurence_from_children!
        current_node
      end
    end

    # formal syntax matcher result
    class Match
      # @return [String]
      attr_accessor :reference
      # @return [FormalSyntax::Node]
      attr_accessor :node
      # @return [Value]
      attr_accessor :value

      def initialize(ref, node)
        @reference = ref
        @node = node
      end

      def to_s
        "#{@reference}: #{@value} => #{@node}"
      end
    end

    # formal syntax matcher
    class Matcher
      # @return [Array<Match>]
      attr_accessor :matches
      attr_accessor :debug

      # @param [Declaration] declaration
      def initialize(declaration)
        @declaration = declaration
        @tree = Tree.tree
        @reference = nil
        @matches = []
        @debug = false
        @match = nil
      end

      # @return [Boolean]
      def match
        @idx = 0
        node = @tree.properties[@declaration.property]
        return false unless node

        #puts "MAX #{node} #{node.occurence} -> #{calc_occurence(node)}"
        puts "MATCH #{node} (#{node.type}) #{node.occurence} WITH #{@declaration.to_s}" if @debug
        @reference = @declaration.property
        # always add inherit keyword
        return true if @declaration.value&.is_a?(Habaki::Ident) && @declaration.value.to_s == "inherit"

        res = rec_match(node)
        @matches.compact!
        @matches.each_with_index do |match, idx|
          match.value = @declaration.values[idx]
        end

        puts "MATCH? #{res} #{node.occurence}, #{@idx} / #{count_values}" if @debug
        res && calc_occurence(node).include?(@idx) && @idx >= count_values
      end

      # @return [Boolean]
      def match?
        @match ||= match
      end

      private

      def calc_occurence(node)
        resolved_node = resolve_node(node)
        if resolved_node.type == :or
          occ_min = resolved_node.occurence.begin
          occ_max = resolved_node.occurence.end
          resolved_node.children.each do |child|
            r_occ = calc_occurence(child)
            #occ_min += r_occ.begin
            occ_max += r_occ.end
          end
          Range.new(occ_min, occ_max)
        else
          resolved_node.occurence
        end
      end

      def resolve_function(value)
        if value.is_a?(Habaki::Function)
          case value.data
          when "calc", "min", "max", "clamp"
            Length.new("0", :px)
          when "attr"
            String.new("")
          else
            value
          end
        else
          value
        end
      end

      def next_value
        @idx += 1
      end

      def match_value_class(value, klass)
        return false unless value.is_a?(klass)

        next_value
        true
      end

      def match_value_class_and_data(value, klass, node)
        return false unless value.is_a?(klass)

        if value.data == node.value
          next_value
          true
        else
          false
        end
      end

      def resolve_node(node)
        return node if %w[percentage length angle number integer string custom-ident uri hexcolor hex-color].include?(node.value)
        resolved_node = node

        if node.type == :ref
          @reference = node.value
          resolved_node = @tree.properties[node.value]
        end

        if node.type == :type
          @reference = "font-variant" if node.value.start_with?("font-variant") # FIXME: dirty hack
          alias_node = @tree.properties["<#{node.value}>"]
          resolved_node = alias_node if alias_node
        end

        if node.type == :function_ref
          alias_node = @tree.properties["<#{node.value}()>"]
          resolved_node = alias_node if alias_node
        end

        resolved_node
      end

      def save_state(node, res)
        @matches[@idx] = Match.new(@reference, node) if res && !@matches[@idx]
      end

      def count_values
        @declaration.values.length
      end

      def rec_match(node)
        value = resolve_function(@declaration.values[@idx])
        return false unless value

        resolved_node = resolve_node(node)

        match = false
        loop = resolved_node.occurence.end > count_values ? count_values : (resolved_node.occurence.end - resolved_node.occurence.begin + 1)

        puts "[#{@idx}/#{count_values}] #{resolved_node.occurence}/#{loop} #{value} => #{resolved_node} (#{resolved_node.type})" if @debug

        loop.times do |i|
          occ_match =
            case resolved_node.type
            when :or_and
              res = false
              resolved_node.children.each do |child|
                tres = rec_match(child)
                save_state(child, tres)
                res ||= tres
              end
              res
            when :and
              founds = 0
              resolved_node.children.each do |child|
                res = rec_match(child)
                save_state(child, res)
                # puts "AND CHILD #{child.occurence} #{child}" if @debug
                founds += 1 if res
              end
              # puts "AND #{founds} #{resolved_node.occurence} #{resolved_node.occurence.include?(founds)} #{resolved_node}" if @debug
              resolved_node.occurence.include?(founds)
            when :or
              res = false
              resolved_node.children.each do |child|
                tres = rec_match(child)
                save_state(child, tres)
                res ||= tres
                break if tres
              end
              res
            when :number
              match_value_class_and_data(value, Habaki::Number, resolved_node)
            when :type
              case resolved_node.value
              when "percentage"
                match_value_class(value, Habaki::Percentage)
              when "length"
                # 0 is acceptable too
                (match_value_class(value, Habaki::Length) && value.unit) || (match_value_class(value, Habaki::Number) && value.to_f == 0.0)
              when "angle"
                match_value_class(value, Habaki::Angle)
              when "number", "integer"
                match_value_class(value, Habaki::Number)
              when "string", "custom-ident"
                match_value_class(value, Habaki::String) || match_value_class(value, Habaki::Ident)
              when "uri", "url"
                match_value_class(value, Habaki::Url)
              when "hexcolor", "hex-color"
                match_value_class(value, Habaki::HexColor)
              else
                false
              end
            when :ident
              match_value_class_and_data(value, Habaki::Ident, resolved_node)
            when :function
              match_value_class_and_data(value, Habaki::Function, resolved_node)
            when :token
              match_value_class_and_data(value, Habaki::Operator, resolved_node)
            else
              false
            end

          match ||= occ_match
          puts " MATCH OCC? #{i}/#{loop} #{value} : #{resolved_node} #{occ_match} #{match}" if @debug
        end
        match
      end

    end
  end
end
