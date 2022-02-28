require 'habaki'
require 'minitest/autorun'

class TestParserWriter < Minitest::Test
  def setup
  end

  def test_decl
    css = %{
    a {color: blue; text-decoration: underline; font-size: 16px; }
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal "blue", stylesheet.rules.first.declarations.find_by_property("color").value.data
    assert_equal 16.0, stylesheet.rules.first.declarations.find_by_property("font-size").value.data
    assert_equal :px, stylesheet.rules.first.declarations.find_by_property("font-size").value.unit
  end

  def test_decl_del
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    stylesheet.rules.first.declarations.remove_by_property("color")
    assert_equal 1, stylesheet.rules.first.declarations.length
    assert_equal "a {text-decoration: underline; }", stylesheet.string
  end

  def test_decl_add
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    stylesheet.rules.first.declarations.add_by_property("font-size", Habaki::Dimension.new(12, :pt))
    # arbitrary value type
    stylesheet.rules.first.declarations.add_by_property("line-height", Habaki::Value.new("14pt"))
    assert_equal 4, stylesheet.rules.first.declarations.length
    assert_equal "a {color: blue; text-decoration: underline; font-size: 12pt; line-height: 14pt; }", stylesheet.string
  end

  def test_media_sel
    css = %{
    @media print {
    a {color: blue; text-decoration: underline;}
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
    assert_equal 3, stylesheet.rules.medias.select{|media| media.match_type?("print")}.length
    assert_equal 1, stylesheet.rules.medias.select{|media| media.match_type?("screen")}.length

    stylesheet.each_rule do |rule|
      if rule.declarations
        rule.declarations.remove_by_property("font-size")
      end
    end
    stylesheet.compact!
    assert_equal 2, stylesheet.rules.medias.select{|media| media.match_type?("print")}.length

  end

  def test_attr
    assert_identical_css(%{input[value="M"] {color: blue; }})
  end

  def test_mul_attr
    assert_identical_css(%{input[name="A"][value="M"] {color: blue; }})
  end

  def test_import
    assert_identical_css(%{@import "mobstyle.css" screen and (max-width: 768px);})
  end

  def test_media_not
    assert_identical_css(%{@media not screen {
article {
 padding: 1rem 3rem;
}
}})
  end

  def test_media_only
    assert_identical_css(%{@media only screen {
article {
 padding: 1rem 3rem;
}
}})
  end

  def test_media_and
    assert_identical_css(%{@media screen and (min-width: 900px) {
article {
 padding: 1rem 3rem;
}
}})
  end

  def test_media_exp_only
    assert_identical_css(%{@media (min-width: 900px) {
a {
 color: black;
}
}})
  end

  def test_media_no_value
    assert_identical_css(%{@media (monochrome) {
a {
 color: black;
}
}})
  end

  def test_namespace
    assert_identical_css(%{@namespace "http://www.w3.org/1999/xhtml";
@namespace svg "http://www.w3.org/2000/svg";
a {}
svg|a {}
*|a {}})
  end

  def test_namespace_attr
    assert_identical_css(%{@namespace epub "http://www.idpf.org/2007/ops";
[epub|type~="toc"] {}})
  end

  def test_supports
    assert_identical_css(%{@supports (transform-style: preserve-3d) {
a {color: black; }
}})
  end

  def test_supports_and
    assert_identical_css(%{@supports (display: grid) and (display: inline-grid) {
a {color: black; }
}})
  end

  def test_supports_not
    css = %{@supports (display: grid) and (not (display: inline-grid)) {
a {color: black; }
}}
    stylesheet = Habaki::Stylesheet.parse(css)
    # TODO: fix double parentheses problem
    # assert_equal css, stylesheet.string
  end

  def test_supports_or
    assert_identical_css(%{@supports (transform-style: preserve-3d) or ((-moz-transform-style: preserve-3d) or ((-o-transform-style: preserve-3d) or (-webkit-transform-style: preserve-3d))) {
a {color: black; }
}})
  end

  def test_pseudo
    assert_identical_css(%{a:hover {color: blue; }
p.nt:nth-of-type(3n) {color: red; }
li:nth-last-child(3n+2) {color: green; }})
  end


  def test_charset
    assert_identical_css(%{@charset "utf-8";})
  end

  # TODO
  if false

    def test_host
      assert_identical_css(%{:host(.special-custom-element) {font-weight: bold; }})
    end
  end

  def test_invalid
    assert_identical_css(%{p {padding: 4m; font-size: %; color: #; weight: em; }})
  end

  def test_inline
    css = %{font-size: 12pt; color: blue; }
    assert_equal css, Habaki::Declarations.parse(css).string
  end

  def test_position
    css = %{body {font-size:12px; color: black;}
p {text-indent: 1em;}
a {color: blue}
}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal 1, stylesheet.rules[0].selectors.first.sub_selectors.first.first.position.line
    assert_equal 6, stylesheet.rules[0].selectors.first.sub_selectors.first.first.position.column
    assert_equal 2, stylesheet.rules[1].selectors.first.sub_selectors.first.first.position.line
    assert_equal 3, stylesheet.rules[1].selectors.first.sub_selectors.first.first.position.column
    assert_equal 3, stylesheet.rules[2].selectors.first.sub_selectors.first.first.position.line
    assert_equal 3, stylesheet.rules[2].selectors.first.sub_selectors.first.first.position.column

    assert_equal 1, stylesheet.rules[0].declarations.first.position.line
    assert_equal 22, stylesheet.rules[0].declarations.first.position.column
    assert_equal 36, stylesheet.rules[0].declarations.last.position.column
    assert_equal 2, stylesheet.rules[1].declarations.first.position.line
    assert_equal 21, stylesheet.rules[1].declarations.first.position.column
    assert_equal 3, stylesheet.rules[2].declarations.first.position.line
    assert_equal 16, stylesheet.rules[2].declarations.first.position.column
  end

  def test_error
    css = %{a,{ }
div {color: green; }
.inv { invalid }}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal 2, stylesheet.errors.length
    assert_equal 1, stylesheet.errors[0].line
    assert_equal 3, stylesheet.errors[0].column
    assert_equal 3, stylesheet.errors[1].line
    assert_equal 16, stylesheet.errors[1].column
    assert_equal %{div {color: green; }
.inv {}}, stylesheet.string
  end

  private

  def assert_identical_css(css)
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal css, stylesheet.string
  end

end
