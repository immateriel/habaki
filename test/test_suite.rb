require 'habaki'
require 'minitest/autorun'

# test parser/writer for files in suite directory
class TestSuite < Minitest::Test
  Dir.glob("test/suite/*.css").each do |f|
      define_method "test_suite_#{File.basename(f, ".css").gsub("-","_")}" do
      input = strip_css(File.read(f))
      stylesheet = Habaki::Stylesheet.parse_file(f)
      output = strip_css(stylesheet.to_s)
      # output should be identical to input
      assert_identical_css(input, output)
    end
  end

  private

  def assert_identical_css(source, dest)
    assert_equal source, dest
  end

  def strip_css(data)
    data.split("\n").map do |l|
      l.strip.gsub(/\s;/,";").gsub(/,\s/,",").gsub(/\{\s/,"{").gsub(/;\s*\}/,"}").
        gsub(/!\s/,"!").gsub(/:\s/,":").gsub(/\s?(-|\+|\/)\s?/,'\1').gsub(/::/,":").
        gsub(/url\(['"]([^'"]+)['"]\)/,'url(\1)').gsub(/"/,"'").gsub(/\s+/," ")
    end.select do |l|
      l != ""
    end.join("\n").gsub(/;\n}/,"}").gsub(/,\n/,",").gsub(/;\n/,"; ").gsub(/{\n/,"{").gsub(/\/\*[^\*]+\*\/\n?/,"")
  end

end
