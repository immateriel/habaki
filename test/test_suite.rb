require 'habaki'
require 'minitest/autorun'

class TestSuite < Minitest::Test
  def setup
  end

  Dir.glob("test/suite/*.css").each do |f|
      define_method "test_suite_#{File.basename(f, ".css").gsub("-","_")}" do
      input = strip_css(File.read(f))
      stylesheet = Habaki::Stylesheet.parse(File.read(f))
      output = strip_css(stylesheet.to_s)
      assert_identical_css(input, output)
    end
  end

  private

  def assert_identical_css(source, dest)
    source1 = source #.gsub(/\s+/," ")
    dest1 = dest #.gsub(/\s+/," ")
    assert_equal source1, dest1
  end

  def strip_css(data)
    data.split("\n").map do |l|
      l.strip.gsub(/\s;/,";").gsub(/,\s/,",").gsub(/\{\s/,"{").gsub(/;\s*\}/,"}").
        gsub(/url\(['"]([^'"]+)['"]\)/,'url(\1)').gsub(/"/,"'").gsub(/\s+/," ")
    end.select do |l|
      l != ""
    end.join("\n").gsub(/;\n}/,"}").gsub(/;\n/,"; ").gsub(/{\n/,"{").gsub(/\/\*[^\*]+\*\/\n?/,"")
  end

end
