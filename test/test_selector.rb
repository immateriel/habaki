require 'habaki'
require 'nokogiri'
require 'minitest/autorun'

class TestSelector < Minitest::Test
  def setup
  end

  def test_tag
    css = %{
    a {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selectors = stylesheet.rules.first.selectors.first.sub_selectors.first
    assert selectors.tag_match?("a")
    refute selectors.tag_match?("h1")
  end

  def test_class
    css = %{
    .l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first
    assert selector.class_match?("l")
    refute selector.class_match?("ll")
  end

  def test_tag_class
    css = %{
    a.l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first
    assert selector.tag_match?("a") && selector.class_match?("l")
  end

  def test_id
    css = %{
    #l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first
    assert selector.id_match?("l")
    refute selector.id_match?("ll")
  end

  def test_html_tag
    css = %{
    div {color: blue;}
    }
    html = %{
    <html>
    <div>blue text</div>
    </html>
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first

    found_elements = selector.select(Habaki::NokogiriSelectorVisitor.new(Nokogiri::HTML.parse(html)))
    assert_equal 1, found_elements.length
    assert_equal "blue text", found_elements.first.element.text
  end

  def test_html_class
    css = %{.bl {color: blue;}}
    html = %{<html>
    <div class="bl">blue text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_id
    css = %{#bl {color: blue;}}
    html = %{<html>
    <div id="bl">blue text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_tag_class
    css = %{div.bl {color: blue;}}
    html = %{<html>
    <div class="bl">blue text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_descendant
    css = %{div.bl em {color: blue;}}
    html = %{<html>
    <div class="bl"><div><em>blue text</em></div></div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_child
    css = %{div.bl > em {color: blue;}}
    html = %{<html>
    <div class="bl"><em>blue text</em></div>
    <div class="bl"><div><em>other text</em></div></div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_direct_adjacent
    css = %{div.bl span + em {color: blue;}}
    html = %{<html>
    <div class="bl"><span>direct</span><em>blue text</em></div>
    <div class="bl"><span>direct</span><strong>other</strong><em>text</em></div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_indirect_adjacent
    css = %{div.bl span ~ em {color: blue;}}
    html = %{<html>
    <div class="bl"><span>direct</span><strong>other</strong><em>blue text</em></div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_exact
    css = %{div[data-c="blue"] {color: blue;}}
    html = %{<html>
    <div data-c="blue">blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_begin
    css = %{div[data-c^="blue"] {color: blue;}}
    html = %{<html>
    <div data-c="blue_etc">blue text</div>
    <div data-c="etc_blue">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_end
    css = %{div[data-c$="blue"] {color: blue;}}
    html = %{<html>
    <div data-c="etc_blue">blue text</div>
    <div data-c="blue_etc">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_mul
    css = %{div[data-c="blue"][data-e="really_blue"] {color: blue;}}
    html = %{<html>
    <div data-c="blue" data-e="really_blue">blue text</div>
    <div data-c="blue">not blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  def test_html_attr_contain
    css = %{div[data-c*="blue"] {color: blue;}}
    html = %{<html>
    <div data-c="contain_blue_etc">blue text</div>
    <div data-c="red">red text</div>
    <div>other text</div>
    </html>}

    assert_selector_found(css, html, "blue text")
  end

  private

  def assert_selector_found(css, html, text)
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first

    found_elements = selector.select(Habaki::NokogiriSelectorVisitor.new(Nokogiri::HTML.parse(html)))
    assert_equal 1, found_elements.length
    assert_equal text, found_elements.first.element.text
  end
end
