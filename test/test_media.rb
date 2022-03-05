require 'habaki'
require 'minitest/autorun'

class TestMisc < Minitest::Test
  def test_type
    css = %{
    @media screen {
     a {color: blue;}
    }}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert stylesheet.rules.medias.first.media_match?("screen")
    refute stylesheet.rules.medias.first.media_match?("print")
  end

  def test_exp
    css = %{
    @media screen and (min-width: 600px) and (max-width: 900px) {
     a {color: blue;}
    }}
    stylesheet = Habaki::Stylesheet.parse(css)
    require 'pp'
    visitor = Habaki::Visitor::Media.new("screen", 800)
    assert stylesheet.rules.medias.first.media_match?(visitor)
    visitor = Habaki::Visitor::Media.new("screen", 1024)
    refute stylesheet.rules.medias.first.media_match?(visitor)
  end

  def test_media_sel
    css = %{
    @media print {
    a {color: blue; text-decoration: underline;}
    }
    @media print,screen {
    p {color: black;}
    }
    @media all {
    div {color: black;}
    }
    @media (min-width: 100px) {
    div {font-size: 10pt;}
    }
    @media not screen {
    p {font-size: 12pt;}
    }}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal 4, stylesheet.rules.medias.select { |media| media.media_match?("print") }.length
    assert_equal 2, stylesheet.rules.medias.select { |media| media.media_match?("screen") }.length

    stylesheet.each_rule do |rule|
      next unless rule.declarations
      rule.declarations.remove_by_property("font-size")
    end
    stylesheet.compact!
    assert_equal 3, stylesheet.rules.medias.select { |media| media.media_match?("print") }.length
  end

end
