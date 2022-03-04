Fast and full featured CSS parser/writer for ruby

Use WebKit based https://github.com/hackers-painters/katana-parser custom fork, support CSS3 syntax

# Usage

```ruby
require 'habaki'

data = %{
body {color: #444444;}
p {font-size: 0.9em}
}

# parse full stylesheet
stylesheet = Habaki::Stylesheet.parse(data)
stylesheet.has_selector?("p")
#=> true
stylesheet.has_selector?("a")
#=> false

# remove a declaration
declarations = stylesheet.find_declarations_by_selector("p").first
declarations.remove_by_property("font-size")
stylesheet.to_s
#=> "body {color: grey; }\np {}"

# add a declaration
declarations = stylesheet.find_declarations_by_selector("body").first
declarations.add_by_property("font-size", Habaki::Dimension.new(0.9, :em))
stylesheet.to_s
#=> "body {color: grey; font-size: 0.9em; }\np {}"

# compact empty declarations
stylesheet.compact!
stylesheet.to_s
#=> "body {color: grey; font-size: 0.9em; }"

# add rule
rule = stylesheet.add_by_selectors("p")
decl = rule.declarations.add_by_property("text-indent", Habaki::Dimension.new(1.4, :em))
stylesheet.to_s
#=> "body {color: #444444; font-size: 0.9em; }\np {text-indent: 1.4em; }"

# check declaration validity
decl.check
#=> true
decl = rule.declarations.add_by_property("color", Habaki::Ident.new("invalid"))
stylesheet.to_s
#=> "body {color: #444444; font-size: 0.9em; }\np {text-indent: 1.4em; color: invalid; }"
decl.check
#=> false

# parse declarations only
decls = Habaki::Declarations.parse("font-size: 1em; color: black;")
decls.to_s
# => "font-size: 1em; color: black; "

# parse selectors only
sels = Habaki::Selectors.parse("div, p, span")
sels.to_s
# => "div,p,span"
```

# TODO
- attribute match type (case sensitive, insensitive)
- implement @keyframes
- implement :host()
- parse comments
