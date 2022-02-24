require 'habaki'
require 'minitest/autorun'

class TestSuite < Minitest::Test
  def setup
  end

  def test_decl
    css = %{
    a {color: blue; text-decoration: underline;}
    }

    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)

    assert_equal "blue", stylesheet.rules.first.declarations.select{|decl| decl.property == "color"}.first.values.first.value
  end

  def test_decl_del
    css = %{
    a {color: blue; text-decoration: underline;}
    }

    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)

    stylesheet.rules.first.declarations.reject!{|decl| decl.property == "color"}
    assert_equal 1, stylesheet.rules.first.declarations.length
    assert_equal "a {text-decoration: underline; }", stylesheet.string
  end

  def test_media_not
    css = %{@media not screen {
article {
 padding: 1rem 3rem;
}
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_media_only
    css = %{@media only screen {
article {
 padding: 1rem 3rem;
}
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_media_and
    css = %{@media screen and (min-width: 900px) {
article {
 padding: 1rem 3rem;
}
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

end
