require 'test_helper'
require 'nokogiri'

class TestSelector < Minitest::Test
  def setup
  end

  def test_tag
    css = %{
    a {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    selectors = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selectors.tag_match?("a")
    refute selectors.tag_match?("h1")
  end

  def test_class
    css = %{
    .l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.class_match?("l")
    refute selector.class_match?("ll")
  end

  def test_tag_class
    css = %{
    a.l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.tag_match?("a")
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.last
    assert selector.class_match?("l")
  end

  def test_id
    css = %{
    #l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.id_match?("l")
    refute selector.id_match?("ll")
  end

  def test_find
    css = %{
    @media screen {
     a {color: blue;}
    }
    p {font-size: 0.9em}
    }
    stylesheet = Habaki::Stylesheet.parse(css)
    assert_equal 1, stylesheet.find_by_selector("a").length
    assert_equal 0, stylesheet.rules.find_by_selector("a").length
    assert_equal 1, stylesheet.rules.find_by_selector("p").length
  end

  def test_html_tag
    css = %{
    div {color: blue;}
    }
    html = %{
    <html><body>
    <div>blue text</div>
    </body></html>
    }

    assert_selector_found(css, html, "blue text")
  end

  def test_html_tag_wildcard
    css = %{* {color: blue;}}
    html = %{<html><body><div>blue text</div></html>}

    found_elements = select_elements(css, html)
    assert_equal 3, found_elements.length
  end

  def test_html_class
    css = %{.bl {color: blue;}}
    html = %{<html><body>
    <div class="bl">blue text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_id
    css = %{#bl {color: blue;}}
    html = %{<html><body>
    <div id="bl">blue text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_tag_class
    css = %{div.bl {color: blue;}}
    html = %{<html><body>
    <div class="bl">blue text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_descendant
    css = %{div.bl em {color: blue;}}
    html = %{<html><body>
    <div class="bl"><div><em>blue text</em></div></div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_child
    css = %{div.bl > em {color: blue;}}
    html = %{<html><body>
    <div class="bl"><em>blue text</em></div>
    <div class="bl"><div><em>other text</em></div></div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_direct_adjacent
    css = %{div.bl span + em {color: blue;}}
    html = %{<html><body>
    <div class="bl"><span>direct</span><em>blue text</em></div>
    <div class="bl"><span>direct</span><strong>other</strong><em>text</em></div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_indirect_adjacent
    css = %{div.bl span ~ em {color: blue;}}
    html = %{<html><body>
    <div class="bl"><span>direct</span><strong>other</strong><em>blue text</em></div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_exact
    css = %{div[data-c="blue"] {color: blue;}}
    html = %{<html><body>
    <div data-c="blue">blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_begin
    css = %{div[data-c^="blue"] {color: blue;}}
    html = %{<html><body>
    <div data-c="blue_etc">blue text</div>
    <div data-c="etc_blue">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_end
    css = %{div[data-c$="blue"] {color: blue;}}
    html = %{<html><body>
    <div data-c="etc_blue">blue text</div>
    <div data-c="blue_etc">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_mul
    css = %{div[data-c="blue"][data-e="really_blue"] {color: blue;}}
    html = %{<html><body>
    <div data-c="blue" data-e="really_blue">blue text</div>
    <div data-c="blue">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_contain
    css = %{div[data-c*="blue"] {color: blue;}}
    html = %{<html><body>
    <div data-c="contain_blue_etc">blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_pseudo_last_child
    css = %{div p:last-child {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>other text</p>
    <p>blue text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_pseudo_only_child
    css = %{div p:only-child {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>other text</p>
    </div>
    <div>
    <p>blue text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_pseudo_nth_child
    css = %{div p:nth-child(2) {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>blue text</p>
    <p>other text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")

    css = %{div p:nth-child(odd) {color: blue;}}
    html = %{<html><body>
    <div>
    <p>blue text</p>
    <p>other text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")

    css = %{div p:nth-child(even) {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>blue text</p>
    <p>other text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")

    css = %{div p:nth-child(2n) {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>blue text</p>
    <p>other text</p>
    </div>
    </body></html>}

    assert_selector_found(css, html, "blue text")

    css = %{div span:nth-child(2n+1) {color: blue;}}
    html = %{<html><body>
    <div class="first">
    <span>Span 1!</span>
    <span>Span 2</span>
    <span>Span 3!</span>
    <span>Span 4</span>
    <span>Span 5!</span>
    <span>Span 6</span>
    <span>Span 7!</span>
    </div>
    </body></html>}

    found_elements = select_elements(css, html)
    assert_equal 4, found_elements.length
    assert_equal "Span 1!", found_elements[0].text
    assert_equal "Span 3!", found_elements[1].text
    assert_equal "Span 5!", found_elements[2].text
    assert_equal "Span 7!", found_elements[3].text

    css = %{div p:nth-child(xx) {color: blue;}}
    html = %{<html><body>
    <div>
    <p>other text</p>
    <p>blue text</p>
    <p>other text</p>
    </div>
    </body></html>}

    found_elements = select_elements(css, html)
    assert_equal 0, found_elements.length
  end

  def test_matching_rules
    css = %{@font-face {font-family: TestFont}
div.bl {color: blue;}
p {font-size:12px}
a {text-decoration: underline}
.kl {font-style: underline}
span.kl {font-weight: bold}
div.kl {font-weight: bolder}
p span {color: red;}
span {font-size: 11px; color: green !important}
}
    html = %{<html><body>
    <div class="bl">blue text</div>
    <div>other <span>text</span></div>
    <p>Paragraph 1</p>
    <p class="para">Paragraph <span class="kl">2</span></p>
    </body></html>}

    stylesheet = Habaki::Stylesheet.parse(css)
    doc = Nokogiri::HTML.parse(html)
    el = doc.root.search("div")[1]
    assert_equal 0, stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(el)).length
    el = doc.root.search("div")[0]
    assert_equal 1, stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(el)).length
    el = doc.root.search("span")[1]
    found_rules = stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(el))
    assert_equal 4, found_rules.length
    assert_equal "span {font-size: 11px; color: green !important;}", found_rules[0].to_s
    assert_equal "p span {color: red;}", found_rules[1].to_s
    assert_equal ".kl {font-style: underline;}", found_rules[2].to_s
    assert_equal "span.kl {font-weight: bold;}", found_rules[3].to_s

    decls = stylesheet.find_matching_declarations(Habaki::Visitor::NokogiriElement.new(el))
    assert_equal Habaki::Ident.new("green"), decls.find_by_property("color")&.value
  end

  private

  def select_elements(css, html)
    stylesheet = Habaki::Stylesheet.parse(css)
    rule = stylesheet.rules.first
    elements = []
    Habaki::Visitor::NokogiriElement.new(Nokogiri::HTML.parse(html)).traverse do |el|
      elements << el if rule.element_match?(el)
    end
    elements
  end

  def assert_selector_found(css, html, text)
    found_elements = select_elements(css, html)
    assert_equal 1, found_elements.length
    assert_equal text, found_elements.first.text
  end
end
