Fast and full featured CSS parser/writer for ruby.

Use WebKit based https://github.com/hackers-painters/katana-parser custom fork for low-level parsing, support CSS3 syntax.

# Usage

```ruby
require 'habaki'

css_data = %{
body {color: #444444;}
p {font-size: 0.9em}
p span {color: black}
span.tiny {font-size: 0.8em}
}

# parse full stylesheet
stylesheet = Habaki::Stylesheet.parse(css_data)
stylesheet.has_selector?("p")
# => true
stylesheet.has_selector?("a")
# => false

# remove a declaration
rule = stylesheet.find_by_selector("p").first
rule.declarations.remove_by_property("font-size")
stylesheet.to_s
# => "body {color: grey; }\np {}"

# add a declaration
rule = stylesheet.find_by_selector("body").first
rule.declarations.add_by_property("font-size", Habaki::Length.new(0.9, :em))
stylesheet.to_s
# => "body {color: grey; font-size: 0.9em; }\np {}"

# compact empty declarations
stylesheet.compact!
stylesheet.to_s
# => "body {color: grey; font-size: 0.9em; }"

# add rule
rule = stylesheet.rules.add_by_selector("p")
# => "body {color: #444444; font-size: 0.9em; }\np {}"
decl = rule.declarations.add_by_property("text-indent", Habaki::Length.new(1.4, :em))
stylesheet.to_s
# => "body {color: #444444; font-size: 0.9em; }\np {text-indent: 1.4em; }"

# check declaration validity
decl.check
# => true
decl = rule.declarations.add_by_property("color", Habaki::Ident.new("invalid"))
stylesheet.to_s
# => "body {color: #444444; font-size: 0.9em; }\np {text-indent: 1.4em; color: invalid; }"
decl.check
# => false

# advanced check
matcher = Habaki::FormalSyntax::Matcher.new(Habaki::Declarations.parse("border: 1px solid #ff000;").first)
matcher.match
# => true
matcher.matches.map(&:to_s)
# => ["border: 1px => <length>", "border: solid => solid", "border: #ff0000 => <hex-color>"]

# parse declarations only
decls = Habaki::Declarations.parse("font-size: 1em; color: black;")
decls.to_s
# => "font-size: 1em; color: black; "

# parse selectors only
sels = Habaki::Selectors.parse("div, p, span")
sels.to_s
# => "div,p,span"

# advanced selector matching
require 'nokogiri'
html_data = %{
    <html><body>
    <p>text <span>black</span></p>
    <p><span class="tiny">tiny black</span></p>
    </body></html>
    }
doc = Nokogiri::HTML.parse(html_data)
rules = stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(doc.root.at("//body")))
rules.length
# => 1
rules.first.to_s
# => "body {color: #444444; }"

rules = stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(doc.root.search("//span")[0]))
rules.length
# => 1
rules.first.to_s
# => "p span {color: black; }"

rules = stylesheet.find_matching_rules(Habaki::Visitor::NokogiriElement.new(doc.root.search("//span")[1]))
rules.length
# => 2
rules.map(&:to_s)
# => ["p span {color: black; }", "span.tiny {font-size: 0.8em; }"]
```

# TODO
- parser/writer: implement @page pseudo class
- parser: attribute match type (case sensitive, insensitive)
- parser: implement @keyframes
- parser: implement :host()
- parser: parse comments
