require 'habaki'
require 'minitest/autorun'

class TestSuite < Minitest::Test
  def setup
  end

  Dir.glob("test/suite/*.css").each do |f|
      define_method "test_suite_#{File.basename(f, ".css").gsub("-","_")}" do
      input = strip_css(File.read(f))
      ast = Habaki::Stylesheet.new
      ast.parse(File.read(f))
      output = strip_css(ast.to_s)
      assert_identical_css(input, output)
    end
  end

  private

  def assert_identical_css(source, dest)
    source1 = source #.gsub(/\s+/," ")
    dest1 = dest #.gsub(/\s+/," ")
    #diff source1, dest1
    assert_equal source1, dest1
  end

  def diff str1, str2
    system "diff #{file_for str1} #{file_for str2}"
  end

  def file_for text
    exp = Tempfile.new("bk", "/tmp").open
    exp.write(text)
    exp.close
    exp.path
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
