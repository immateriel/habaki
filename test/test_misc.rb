require 'test_helper'

class TestMisc < Minitest::Test
  def test_dimension
    assert Habaki::Length.new(6, :pt).absolute?
    assert Habaki::Length.new(1, :em).relative?

    # to_px
    assert_equal 8.0, Habaki::Length.new(8, :px).to_px
    assert_equal 8.0, Habaki::Length.new(6, :pt).to_px.round
    assert_equal 8.0, Habaki::Length.new(0.0833, :in).to_px.round
    assert_equal 8.0, Habaki::Length.new(0.2116, :cm).to_px.round
    assert_equal 8.0, Habaki::Length.new(2.116, :mm).to_px.round
    assert_nil Habaki::Length.new(1, :em).to_px

    # to_em
    assert_equal 0.5, Habaki::Length.new(8, :px).to_em.round(1)
    assert_equal 0.5, Habaki::Length.new(6, :pt).to_em.round(1)
    assert_equal 0.5, Habaki::Length.new(0.0833, :in).to_em.round(1)
    assert_equal 0.5, Habaki::Length.new(0.2116, :cm).to_em.round(1)
    assert_equal 0.5, Habaki::Length.new(2.116, :mm).to_em.round(1)

    assert_equal 0.5, Habaki::Length.new(0.5, :em).to_em.round(1)
  end

  def test_length_operators
    assert Habaki::Length.new(8, :px) == Habaki::Length.new(8, :px)
    assert Habaki::Length.new(10, :px) >= Habaki::Length.new(8, :px)
    assert Habaki::Length.new(10, :px) > Habaki::Length.new(8, :px)
    assert Habaki::Length.new(8, :px) < Habaki::Length.new(10, :px)
    assert Habaki::Length.new(8, :px) <= Habaki::Length.new(10, :px)

    assert Habaki::Length.new(12, :pt) > Habaki::Length.new(15, :px)

    assert Habaki::Length.new(2, :em) > Habaki::Length.new(1, :em)

    assert Habaki::Length.new(12, :pt) == Habaki::Length.new(16, :px)

    assert_equal Habaki::Length.new(14, :px), Habaki::Length.new(12, :px) +  Habaki::Length.new(2, :px)
    assert_equal Habaki::Length.new(14, :px), Habaki::Length.new(16, :px) -  Habaki::Length.new(2, :px)

    assert_equal Habaki::Length.new(14, :px), Habaki::Length.new(7, :px) * 2.0
    assert_equal Habaki::Length.new(14, :px), Habaki::Length.new(28, :px) / 2.0

    assert_equal Habaki::Length.new(14, :px), Habaki::Length.new(7, :px) * Habaki::Percentage.new(200)

    refute Habaki::Length.new(12, :pt) == Habaki::Length.new(1, :em)

    assert_raises(ArgumentError) do
      Habaki::Length.new(12, :pt) > Habaki::Ident.new("smaller")
    end

    assert_raises(ArgumentError) do
      Habaki::Length.new(12, :pt) / Habaki::Length.new(12, :pt)
    end
  end

  def test_property_table
    assert_decl_match("font-size: 10px;")
    assert_decl_match("background-color: red;")
    assert_decl_match("background: red;")
    assert_decl_match("border: 1px solid #ff0000;")

    assert_decl_match("border-top: solid;")
    assert_decl_match("border-top: #CDCDCD;")
    assert_decl_match("border-top: 1px;")
    assert_decl_match("font-family: 'Lettrines';")
    assert_decl_match("font-family: Police, serif;")
    assert_decl_match("font-family: 'Bookman Old Style','Book Antiqua','Georgia','Century Schoolbook','Times New Roman',serif;")
    assert_decl_match("font: oblique small-caps 300 12pt/18px Police, sans-serif;")
    assert_decl_match("font-size: smaller;")
    assert_decl_match("margin-left: -1%;")
    assert_decl_match("margin: 0 0 1em 1em;")
    assert_decl_match("background-size: 0.6in;")
    assert_decl_match("list-style: katakana inside url(chess.png); ")
    assert_decl_match("max-width: 100%;")
    assert_decl_match("border: #CCCC99;")
    assert_decl_match("color: inherit;")
    assert_decl_match(%{background: center / contain no-repeat url("../../media/examples/firefox-logo.svg"), #eee 35% url("../../media/examples/lizard.png");})
    assert_decl_match("cursor: inherit;")
    assert_decl_match("background: inherit;")
    assert_decl_match("src: url(Fonts/AveriaSerif-Light.ttf);")
    assert_decl_match("border: #CCCC99 1px solid;")
    assert_decl_match("content: 'p. ';")
    assert_decl_match("content: 'a' 'b';")
    assert_decl_match("content: 'a' attr(data-eq);")
    assert_decl_match("max-width: calc(200px - 120px);")

    refute_decl_match("border: invalid;")
    refute_decl_match("border: 1px solid #ff0000 red;")
    refute_decl_match("background-image: url('img.png') 50% 50% no-repeat;")
    refute_decl_match("border-size: 1px;")

    # should match
    #assert_decl_match("background-position: top;", true)
  end

  private

  def assert_decl_match(decl, debug = false)
    matcher = Habaki::FormalSyntax::Matcher.new(Habaki::Declarations.parse(decl).first)
    matcher.debug = debug
    match = matcher.match?
    puts matcher.matches if debug
    assert match
  end

  def refute_decl_match(decl, debug = false)
    matcher = Habaki::FormalSyntax::Matcher.new(Habaki::Declarations.parse(decl).first)
    matcher.debug = debug
    match = matcher.match?
    puts matcher.matches if debug
    refute match
  end
end
