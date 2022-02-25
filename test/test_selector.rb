require 'habaki'
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

  def test_attribute
    css = %{
    [data-c='lnk'] {color: blue;}
    a {color: red;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules[0].selectors.first.sub_selectors.first
    assert selector.attribute_match?("data-c", "lnk")
    refute selector.attribute_match?("data-c", "l")

    selector = stylesheet.rules[1].selectors.first.sub_selectors.first
    refute selector.attribute_match?("data-c", "lnk")
  end

  def test_mul
    css = %{
    a#l div {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    #require 'pp'
    #pp stylesheet.rules.first.selectors.first
  end

end
