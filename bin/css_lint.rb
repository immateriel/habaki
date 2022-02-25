require "habaki"

filename = ARGV[0]

stylesheet = Habaki::Stylesheet.parse(File.read(filename))
if stylesheet.errors.length > 0
  stylesheet.errors.each do |error|
    STDERR.puts "ERROR: #{error.line}:#{error.column} #{error.message}"
  end
end

puts stylesheet.string(0)
