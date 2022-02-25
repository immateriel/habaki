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
    assert_equal "blue", stylesheet.rules.first.declarations.select { |decl| decl.property == "color" }.first.values.first.value
  end

  def test_decl_del
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    stylesheet.rules.first.declarations.reject! { |decl| decl.property == "color" }
    assert_equal 1, stylesheet.rules.first.declarations.length
    assert_equal "a {text-decoration: underline; }", stylesheet.string
  end

  def test_import
    css = %{@import "mobstyle.css" screen and (max-width: 768px);}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
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

  def test_media_exp_only
    css = %{@media (min-width: 900px) {
a {
 color: black;
}
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_media_no_value
    css = %{@media (monochrome) {
a {
 color: black;
}
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_namespace
    css = %{@namespace "http://www.w3.org/1999/xhtml";
@namespace svg "http://www.w3.org/2000/svg";
a {}
svg|a {}
*|a {}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert 2, stylesheet.rules.namespaces.length
    assert_equal css, stylesheet.string
  end

  def test_namespace_attr
    css = %{@namespace epub "http://www.idpf.org/2007/ops";
[epub|type~="toc"] {}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_supports
    css = %{@supports (transform-style: preserve-3d) {
a {color: black; }
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_supports_and
    css = %{@supports (display: grid) and (display: inline-grid) {
a {color: black; }
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_supports_not
    css = %{@supports (display: grid) and (not (display: inline-grid)) {
a {color: black; }
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    # TODO: fix double parentheses problem
    # assert_equal css, stylesheet.string
  end

  def test_supports_or
    css = %{@supports (transform-style: preserve-3d) or ((-moz-transform-style: preserve-3d) or ((-o-transform-style: preserve-3d) or (-webkit-transform-style: preserve-3d))) {
a {color: black; }
}}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_pseudo
    css = %{a:hover {color: blue; }
p.nt:nth-of-type(3n) {color: red; }
li:nth-last-child(3n+2) {color: green; }}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  # TODO
  if false
    def test_charset
      css = %{@charset "utf-8"; }
      stylesheet = Habaki::Stylesheet.new
      stylesheet.parse(css)
      assert_equal css, stylesheet.string
    end

  def test_host
    css = %{:host(.special-custom-element) {font-weight: bold; }}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end
  end

  def test_invalid
    css = %{p {padding: 4m; font-size: %; color: #; weight: em; }}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

  def test_error
    css=%{a,{ }
div {color: green; }
.inv { invalid }}
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    assert_equal 2, stylesheet.errors.length
    assert_equal 1, stylesheet.errors[0].line
    assert_equal 3, stylesheet.errors[1].line
    assert_equal %{div {color: green; }
.inv {}}, stylesheet.string
  end

end
