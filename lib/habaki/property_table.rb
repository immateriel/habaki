require 'strscan'
require 'yaml'

module Habaki
  # property pattern matching
  module PropertyTable
    class Node
      attr_accessor :parent
      attr_accessor :children
      attr_accessor :type
      attr_accessor :value
      attr_accessor :occurence

      attr_accessor :orig

      def initialize(type = nil, value = nil)
        @type = type
        @value = value
        @children = []
        @occurence = 1..1
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

    class Tree
      attr_accessor :properties

      def initialize
        @properties = {}
        Tree.tree_data.each do |k, v|
          @properties[k] = Tree.parse(v)
        end
        flatten!
      end

      def self.tree
        @@tree ||= self.new
      end

      def self.tree_data
        @@tree_data ||= YAML.load_file(File.join(File.dirname(__FILE__), '../../data/property_table.yml')).freeze
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

      def self.parse(str)
        current_node = Node.new(:and)
        current_node.orig = str
        scanner = StringScanner.new(str)

        until scanner.eos?
          case
          when scanner.scan(/\[/)
            prev_node = current_node
            current_node = Node.new(:and)
            current_node.parent = prev_node
            current_node.occurence = 0..n
          when scanner.scan(/([a-zA-Z-]+)\(/)
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
          when scanner.scan(/\{(\d),(\d)\}/)
            prev_node = current_node.children.last
            prev_node.occurence = (scanner[1].to_i)..(scanner[2].to_i)
          when scanner.scan(/\{(\d)\}/)
            prev_node = current_node.children.last
            prev_node.occurence = (scanner[1].to_i)..(scanner[1].to_i)
          when scanner.scan(/\]/)
            prev_node = current_node
            current_node = current_node.parent
            current_node.push_children prev_node
          when scanner.scan(/\)/)
            prev_node = current_node
            current_node = current_node.parent
            current_node.push_children prev_node
          when scanner.scan(/\s?(\/)\s?/)
            current_node.push_children Node.new(:token, "/")
          when scanner.scan(/\s?(,)\s?/)
            current_node.push_children Node.new(:token, ",")
          when scanner.scan(/<([a-zA-Z-]+)>/)
            current_node.push_children Node.new(:type, scanner[1])
          when scanner.scan(/([a-zA-Z-]+)/)
            current_node.push_children Node.new(:ident, scanner[1]) if scanner[1] != "inherit"
          when scanner.scan(/([0-9]+)/)
            current_node.push_children Node.new(:number, scanner[1].to_i)
          when scanner.scan(/'([a-zA-Z-]+)'/)
            current_node.push_children Node.new(:ref, scanner[1])
          when scanner.scan(/\|\|/)
            current_node.type = :or_and
          when scanner.scan(/\|/)
            current_node.type = :or
          else
            result = scanner.scan(/.+/)
            puts "CANNOT PARSE #{result}"
          end
          scanner.scan(/\s+/)
        end
        current_node
      end
    end

    class Match
      attr_accessor :reference
      attr_accessor :node
      attr_accessor :value

      def initialize(ref, node)
        @reference = ref
        @node = node
      end

      def to_s
        "#{@reference} {#{@node} => #{@value}}"
      end
    end

    class Matcher
      attr_accessor :matches

      def initialize(declaration)
        @declaration = declaration
        @tree = Tree.tree
        @reference = nil
        @matches = []
      end

      # @return [Boolean]
      def match?
        @idx = 0
        node = @tree.properties[@declaration.property]
        # puts "MATCH #{node} (#{node.type}) WITH #{@declaration.to_s}"
        @reference = @declaration.property
        res = rec_match(node)
        @matches.compact!
        @matches.each_with_index do |match, idx|
          match.value = @declaration.values[idx]
        end
        # puts "#{res}, #{@idx} / #{@declaration.values.length}"
        res && @idx >= @declaration.values.length
      end

      private

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
        resolved_node = node
        if node.type == :ref
          @reference = node.value
          resolved_node = @tree.properties[node.value]
        end

        if node.type == :type
          alias_node = @tree.properties["<#{node.value}>"]
          resolved_node = alias_node if alias_node
        end
        resolved_node
      end

      def save_state(node, res)
        @matches[@idx] = Match.new(@reference, node) if res && !@matches[@idx]
      end

      def rec_match(node)
        value = @declaration.values[@idx]
        return false unless value

        resolved_node = resolve_node(node)

        #puts "[#{@idx}] #{value} => #{resolved_node} (#{resolved_node.type})"

        case resolved_node.type
        when :or_and
          resolved_node.children.inject(false) do |result, child|
            res = rec_match(child)
            save_state(child, res)
            result ||= res
          end
        when :and
          founds = 0
          resolved_node.children.each do |child|
            res = rec_match(child)
            save_state(child, res)
            founds += 1 if res
          end
          resolved_node.occurence.include?(founds)
        when :or
          res = false
          resolved_node.children.each do |child|
            res = rec_match(child)
            save_state(child, res)
            break if res
          end
          res
        when :number
          match_value_class_and_data(value, Habaki::Number, resolved_node)
        when :type
          case resolved_node.value
          when "percentage"
            match_value_class(value, Habaki::Percentage)
          when "length"
            match_value_class(value, Habaki::Dimension)
          when "angle"
            match_value_class(value, Habaki::Angle)
          when "number"
            match_value_class(value, Habaki::Number)
          when "string"
            match_value_class(value, Habaki::String) || match_value_class(value, Habaki::Ident)
          when "uri"
            match_value_class(value, Habaki::Url)
          when "hexcolor"
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
      end

    end
  end
end
