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
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.tag_match?("a")
    refute selector.tag_match?("h1")
  end

  def test_class
    css = %{
    .l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.class_match?("l")
    refute selector.class_match?("ll")
  end

  def test_id
    css = %{
    #l {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.id_match?("l")
    refute selector.id_match?("ll")
  end

  def test_attribute
    css = %{
    [data-c='lnk'] {color: blue;}
    }
    stylesheet = Habaki::Stylesheet.new
    stylesheet.parse(css)
    selector = stylesheet.rules.first.selectors.first.sub_selectors.first.first
    assert selector.attribute_match?("data-c", "lnk")
    refute selector.attribute_match?("data-c", "l")
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
