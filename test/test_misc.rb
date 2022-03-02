require 'habaki'
require 'minitest/autorun'

class TestMisc < Minitest::Test
  def setup
  end

  def test_dimension
    assert Habaki::Dimension.new(6, :pt).absolute?
    assert Habaki::Dimension.new(1, :em).relative?

    # to_px
    assert_equal 8.0, Habaki::Dimension.new(8, :px).to_px
    assert_equal 8.0, Habaki::Dimension.new(6, :pt).to_px.round
    assert_equal 8.0, Habaki::Dimension.new(0.0833, :in).to_px.round
    assert_equal 8.0, Habaki::Dimension.new(0.2116, :cm).to_px.round
    assert_equal 8.0, Habaki::Dimension.new(2.116, :mm).to_px.round
    assert_nil Habaki::Dimension.new(1, :em).to_px

    # to_em
    assert_equal 0.5, Habaki::Dimension.new(8, :px).to_em.round(1)
    assert_equal 0.5, Habaki::Dimension.new(6, :pt).to_em.round(1)
    assert_equal 0.5, Habaki::Dimension.new(0.0833, :in).to_em.round(1)
    assert_equal 0.5, Habaki::Dimension.new(0.2116, :cm).to_em.round(1)
    assert_equal 0.5, Habaki::Dimension.new(2.116, :mm).to_em.round(1)

    assert_equal 0.5, Habaki::Dimension.new(0.5, :em).to_em.round(1)
  end

  def test_property_table
    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("font-size: 10px;").first)
    assert matcher.match?

    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("border: 1px solid #ff0000;").first)
    assert matcher.match?

    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("border: invalid;").first)
    refute matcher.match?

    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("border: 1px solid #ff0000 red;").first)
    refute matcher.match?

    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("background: red;").first)
    assert matcher.match?

    matcher = Habaki::PropertyTable::Matcher.new(Habaki::Declarations.parse("font: oblique small-caps 300 12pt/18px Police, sans-serif;").first)
    assert matcher.match?
  end

  def test_create_shorthand
    assert_shorthand_created("border-width: 1px; border-color: red; border-style: solid;",
                             "border: 1px solid red; ")
    assert_shorthand_created(%{border-top-width: auto; border-right-width: thin; border-bottom-width: auto; border-left-width: 0px;},
                             "border-width: auto thin auto 0px; ")

    assert_shorthand_created("margin-right: auto; margin-bottom: 0px; margin-left: auto; margin-top: 0px",
                             "margin: 0px auto 0px auto; ")

    assert_shorthand_created(%{
      background-image: url('chess.png');
      background-color: gray;
      background-position: center -10.2%;
      background-attachment: fixed;
      background-repeat: no-repeat;
    }, "background: url(chess.png) no-repeat fixed center -10.2% gray; ")

    assert_shorthand_created(%{list-style-image: url('chess.png'); list-style-type: katakana;},
                             "list-style: katakana url(chess.png); ")

    assert_shorthand_created(%{list-style-image: url('chess.png'); list-style-type: katakana; list-style-position: inside},
                             "list-style: katakana inside url(chess.png); ")

    assert_shorthand_created(%{font-weight: 300; font-size: 12pt;
      font-family: sans-serif; line-height: 18px;
      font-style: oblique; font-variant: small-caps;},"font: oblique small-caps 300 12pt/18px sans-serif; ")

    assert_shorthand_created(%{font-size: 12pt;},"font-size: 12pt; ")
  end

  def test_expand_shorthand
    if false
    assert_shorthand_expanded("border: 1px solid red;", %{border-top-color: red; border-right-color: red; border-bottom-color: red; border-left-color: red;
border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;
border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; }.gsub(/\n/," "))

    assert_shorthand_expanded("border-width: auto thin auto 0px; ",
                              "border-top-width: auto; border-right-width: thin; border-bottom-width: auto; border-left-width: 0px; ")

    assert_shorthand_expanded("font: oblique small-caps 300 12pt/18px Police,sans-serif; ",%{font-style: oblique; font-variant: small-caps; font-weight: 300; font-size: 12pt;
line-height: 18px; font-family: Police,sans-serif; }.gsub(/\n/," "))

    assert_shorthand_expanded("list-style: katakana inside url(chess.png); ",
                             %{list-style-type: katakana; list-style-position: inside; list-style-image: url(chess.png) ; })
    end

    assert_shorthand_expanded(%{background: url(starsolid.gif) repeat-y fixed #99f;},
                              "background-image: url(starsolid.gif); background-repeat: repeat-y; background-attachment: fixed; background-color: #99f; ")

    #assert_shorthand_expanded(%{background: center / contain no-repeat url("../../media/examples/firefox-logo.svg"),
    #  #eee 35% url("../../media/examples/lizard.png");}, "")
  end

  private

  def assert_shorthand_expanded(from, to)
    decls = Habaki::Declarations.parse(from)
    decls.expand_shorthand!
    assert_equal to, decls.string
  end

  def assert_shorthand_created(from, to)
    decls = Habaki::Declarations.parse(from)
    decls.create_shorthand!
    assert_equal to, decls.string
  end

end
