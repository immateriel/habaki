require "habaki"

filename = ARGV[0]

stylesheet = Habaki::Stylesheet.parse(File.read(filename))
puts stylesheet.string(0)
