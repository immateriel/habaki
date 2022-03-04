require "habaki"

filename = ARGV[0]

stylesheet = Habaki::Stylesheet.parse(File.read(filename))
if stylesheet.errors.any?
  stylesheet.errors.each do |error|
    STDERR.puts "ERROR(#{error.line}:#{error.column}): #{error.message}"
  end
end
stylesheet.each_rule do |rule|
  rule.each_declaration do |declaration|
    unless declaration.check
      prop_node = Habaki::FormalSyntax::Tree.tree.property(declaration.property)
      if prop_node
      STDERR.puts %{WARNING(#{declaration.position.line}:#{declaration.position.column}): "#{declaration}" does not match "#{prop_node}"}
      else
        STDERR.puts %{WARNING(#{declaration.position.line}:#{declaration.position.column}): "#{declaration}" unknown property "#{declaration.property}"}
      end
    end
  end
end

puts stylesheet.string(0)
