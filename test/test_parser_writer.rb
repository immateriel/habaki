require 'test_helper'

class TestParserWriter < Minitest::Test

  def test_parse_empty
    stylesheet = Habaki::Stylesheet.parse("")
    assert_equal 0, stylesheet.rules.length
    stylesheet = Habaki::Stylesheet.parse(nil)
    assert_equal 0, stylesheet.rules.length
  end

  def test_parse_selectors
    assert_equal "div,p,span", Habaki::Selectors.parse("div,p,span").to_s
  end

  def test_parse_and_check_declaration
    decl = Habaki::Declarations.parse("font-size:1em").first
    assert decl.check
    assert_equal "font-size: 1em", decl.to_s

    decl = Habaki::Declarations.parse("font-size:invalid").first
    refute decl.check
    assert_equal "font-size: invalid", decl.to_s
  end

  def test_indented
    css = %{a {color: blue; text-decoration: underline; font-size: 16px;}}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal %{a {
 color: blue;
 text-decoration: underline;
 font-size: 16px;
}}, stylesheet.string(Habaki::Formatter::Indented.new)

  end

  def test_decl
    css = %{
    a {color: blue; text-decoration: underline; font-size: 16px;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal "blue", stylesheet.rules.first.declarations.find_by_property("color").value.data
    assert_equal 16.0, stylesheet.rules.first.declarations.find_by_property("font-size").value.data
    assert_equal :px, stylesheet.rules.first.declarations.find_by_property("font-size").value.unit
  end

  def test_val_del
    css = %{@font-face {src: url(font.ttf), url(font.otf), url(font.woff);}}
    stylesheet = Habaki::Stylesheet.parse(css)
    decl = stylesheet.rules.font_faces.first.declarations.first
    decl.values.remove_value(decl.values.last)
    assert_equal %{@font-face {src: url(font.ttf),url(font.otf);}}, stylesheet.to_s

    stylesheet = Habaki::Stylesheet.parse(css)
    decl = stylesheet.rules.font_faces.first.declarations.first
    decl.values.remove_value(decl.values[2])
    assert_equal %{@font-face {src: url(font.ttf),url(font.woff);}}, stylesheet.to_s

    stylesheet = Habaki::Stylesheet.parse(css)
    decl = stylesheet.rules.font_faces.first.declarations.first
    decl.values.remove_value(decl.values.first)
    assert_equal %{@font-face {src: url(font.otf),url(font.woff);}}, stylesheet.to_s

    # array delete does not manage operators
    stylesheet = Habaki::Stylesheet.parse(css)
    decl = stylesheet.rules.font_faces.first.declarations.first
    decl.values.delete(decl.values.last)
    assert_equal %{@font-face {src: url(font.ttf),url(font.otf),;}}, stylesheet.to_s
  end

  def test_decl_find
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    rule = stylesheet.find_by_selector("a").first
    assert_equal Habaki::Ident.new("blue"), rule.declarations.find_by_property("color").value
    assert_equal Habaki::Ident.new("blue"), rule.declarations["color"].value
    assert_equal Habaki::Ident.new("blue"), rule.declarations[0].value
  end

  def test_decl_del
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    stylesheet.rules.first.declarations.remove_by_property("color")
    assert_equal 1, stylesheet.rules.first.declarations.length
    assert_equal "a {text-decoration: underline;}", stylesheet.to_s
  end

  def test_decl_add
    css = %{
    a {color: blue; text-decoration: underline;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    stylesheet.rules.first.declarations.add_by_property("font-size", Habaki::Length.new(12, :pt))
    # arbitrary value type
    stylesheet.rules.first.declarations.add_by_property("line-height", Habaki::Value.new("14pt"))
    assert_equal 4, stylesheet.rules.first.declarations.length
    assert_equal "a {color: blue; text-decoration: underline; font-size: 12pt; line-height: 14pt;}", stylesheet.to_s
  end

  def test_url
    assert_identical_css(%{div {background-image: url(image.png);}})
    assert_identical_css(%{div {background-image: url("image space.png");}})
    assert_identical_css(%{div {background-image: url();}})
  end

  def test_important
    assert_identical_css(%{p {color: blue !important;}})
    assert_equal %{p {color: blue !important;}}, Habaki::Stylesheet.parse(%{p {color: blue ! important;}}).to_s
  end

  def test_attr
    assert_identical_css(%{input[value="M"] {color: blue;}})
    assert_identical_css(%{input[name="A"][value="M"] {color: blue;}})
    assert_identical_css(%{input[name~="hello"] {color: blue;}})
    assert_identical_css(%{input[name|="hello"] {color: blue;}})
    assert_identical_css(%{input[name$="hello"] {color: blue;}})
    assert_identical_css(%{input[name*="hello"] {color: blue;}})
  end

  def test_import
    assert_identical_css(%{@import "mobstyle.css" screen and (max-width: 768px);})
  end

  def test_media_not
    assert_identical_css(%{@media not screen {
article {padding: 1rem 3rem;}
}})
  end

  def test_media_only
    assert_identical_css(%{@media only screen {
article {padding: 1rem 3rem;}
}})
  end

  def test_media_and
    assert_identical_css(%{@media screen and (min-width: 900px) {
article {padding: 1rem 3rem;}
}})
  end

  def test_media_exp_only
    assert_identical_css(%{@media (min-width: 900px) {
a {color: black;}
}})
  end

  def test_media_no_value
    assert_identical_css(%{@media (monochrome) {
a {color: black;}
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
a {color: black;}
}})
  end

  def test_supports_and
    assert_identical_css(%{@supports (display: grid) and (display: inline-grid) {
a {color: black;}
}})
  end

  def test_supports_not
    css = %{@supports (display: grid) and (not (display: inline-grid)) {
a {color: black;}
}}
    stylesheet = Habaki::Stylesheet.parse(css)
    # TODO: fix double parentheses problem
    # assert_equal css, stylesheet.to_s
  end

  def test_supports_or
    assert_identical_css(%{@supports (transform-style: preserve-3d) or ((-moz-transform-style: preserve-3d) or ((-o-transform-style: preserve-3d) or (-webkit-transform-style: preserve-3d))) {
a {color: black;}
}})
  end

  def test_font_face
      assert_identical_css(%{@font-face {src: url(font.ttf);}})
    end

  def test_page
    assert_identical_css(%{@page {margin: 1cm;}})
    # TODO
    # assert_identical_css(%{@page :first {margin: 1cm;}})
  end

  def test_pseudo
    assert_identical_css(%{a:hover {color: blue;}
p.nt:nth-of-type(3n) {color: red;}
li:nth-last-child(3n+2) {color: green;}})
    assert_identical_css(":root {color: blue;}")
    assert_identical_css("div:empty {margin: 1px;}")
    assert_identical_css("div:first-child {text-indent: 2em;}")
    assert_identical_css("p::first-line {text-indent: 2em;}")
  end

  def test_charset
    assert_identical_css(%{@charset "utf-8";})
  end

  # TODO
  if false

    def test_host
      assert_identical_css(%{:host(.special-custom-element) {font-weight: bold;}})
    end
  end

  def test_invalid
    assert_identical_css(%{p {padding: 4m; font-size: %; color: #; weight: em;}})
  end

  def test_inline
    css = %{font-size: 12pt; color: blue;}
    assert_equal css, Habaki::Declarations.parse(css).to_s
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
div {color: green;}
.inv { invalid }}
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal 2, stylesheet.errors.length
    assert_equal 1, stylesheet.errors[0].line
    assert_equal 3, stylesheet.errors[0].column
    assert_equal 3, stylesheet.errors[1].line
    assert_equal 16, stylesheet.errors[1].column
    assert_equal %{div {color: green;}
.inv {}}, stylesheet.to_s
  end

  def test_error2
    assert_equal "", Habaki::Stylesheet.parse("{border: 1px").to_s
    assert_equal "", Habaki::Declarations.parse("{border: 1px").to_s
    assert_equal "", Habaki::Selectors.parse("{border: 1px").to_s
  end

  private

  def assert_identical_css(css)
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal css, stylesheet.to_s
  end

end
