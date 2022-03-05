require 'test_helper'

class TestShorthand < Minitest::Test
  def test_create_shorthand
    assert_shorthand_created("border-width: 1px; border-color: red; border-style: solid;",
                             "border: 1px solid red; ")

    assert_shorthand_created(%{border-top-width: auto; border-right-width: thin; border-bottom-width: auto; border-left-width: 0px;},
                             "border-width: auto thin auto 0px; ")

    assert_shorthand_created("margin-right: auto; margin-bottom: 0px; margin-left: auto; margin-top: 0px",
                             "margin: 0px auto; ")

    assert_shorthand_created(%{list-style-image: url('chess.png'); list-style-type: katakana;},
                             "list-style: katakana url(chess.png); ")

    assert_shorthand_created(%{list-style-image: url('chess.png'); list-style-type: katakana; list-style-position: inside},
                             "list-style: katakana inside url(chess.png); ")

    assert_shorthand_created(%{font-size: 12pt;}, "font-size: 12pt; ")

    assert_shorthand_created(%{font-weight: 300; font-size: 12pt;
      font-family: sans-serif; line-height: 18px;
      font-style: oblique; font-variant: small-caps;}, "font: oblique small-caps 300 12pt/18px sans-serif; ")

    assert_shorthand_created(%{font-weight: 300; font-size: 12pt;
      font-family: Police,sans-serif; line-height: 18px;
      font-style: oblique; font-variant: small-caps;}, "font: oblique small-caps 300 12pt/18px Police,sans-serif; ")

    # assert_shorthand_created(%{background-image: url('chess.png'); background-color: gray; background-position: center -10.2%; background-attachment: fixed; background-repeat: no-repeat;},
    #                         "background: url(chess.png) no-repeat fixed center -10.2% gray; ")

  end

  def test_expand_shorthand
    assert_shorthand_expanded("border: 1px solid red;", %{border-top-color: red; border-right-color: red; border-bottom-color: red; border-left-color: red;
border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;
border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; }.gsub(/\n/, " "))

    assert_shorthand_expanded("border-width: auto thin auto 0px; ",
                              "border-top-width: auto; border-right-width: thin; border-bottom-width: auto; border-left-width: 0px; ")

    assert_shorthand_expanded("list-style: katakana inside url(chess.png); ",
                              %{list-style-type: katakana; list-style-position: inside; list-style-image: url(chess.png); })

    assert_shorthand_expanded("font: oblique small-caps 300 12pt/18px Police,sans-serif; ", %{font-style: oblique; font-variant: small-caps; font-weight: 300; font-size: 12pt;
line-height: 18px; font-family: Police,sans-serif; }.gsub(/\n/, " "))

    # assert_shorthand_expanded(%{background: url(starsolid.gif) repeat-y fixed #99f;},
    #                          "background-image: url(starsolid.gif); background-repeat: repeat-y; background-attachment: fixed; background-color: #99f; ")
  end

  def test_margin_shorthand
    assert_shorthand_expanded("margin: 1px; ",
                              "margin-top: 1px; margin-right: 1px; margin-bottom: 1px; margin-left: 1px; ")

    assert_shorthand_created("margin-top: 1px; margin-right: 1px; margin-bottom: 1px; margin-left: 1px; ",
                             "margin: 1px 1px; ")

    assert_shorthand_expanded("margin: 1px 2px; ",
                              "margin-top: 1px; margin-right: 2px; margin-bottom: 1px; margin-left: 2px; ")

    assert_shorthand_created("margin-top: 1px; margin-right: 2px; margin-bottom: 1px; margin-left: 2px;",
                             "margin: 1px 2px; ")

    assert_shorthand_expanded("margin: 1px 2px 3px; ",
                              "margin-top: 1px; margin-right: 2px; margin-bottom: 3px; margin-left: 2px; ")

    assert_shorthand_created("margin-top: 1px; margin-right: 2px; margin-bottom: 3px; margin-left: 2px; ",
                             "margin: 1px 2px 3px; ")

    assert_shorthand_expanded("margin: 1px 2px 3px 4px; ",
                              "margin-top: 1px; margin-right: 2px; margin-bottom: 3px; margin-left: 4px; ")

    assert_shorthand_created("margin-top: 1px; margin-right: 2px; margin-bottom: 3px; margin-left: 4px; ",
                             "margin: 1px 2px 3px 4px; ")
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
