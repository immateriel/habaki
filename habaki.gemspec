spec = Gem::Specification.new do |s|
  s.name = "habaki"
  s.version = "0.5.2"
  s.summary = "CSS parser/writer"
  s.description = "Fast and full featured CSS parser/writer for ruby"
  s.author = "Julien Boulnois"
  s.license = "MIT"
  s.homepage = "https://github.com/immateriel/habaki"

  s.extensions = "ext/katana/extconf.rb"
  s.required_ruby_version = ">= 2.4"

  s.files = ["Gemfile"] +
    Dir.glob("ext/**/*.{c,h,rb}") +
    Dir.glob("lib/**/*.{rb}") +
    Dir.glob("data/**/*.yml")

  s.require_paths = ["lib"]

  s.add_development_dependency "nokogiri"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "ruby-prof"

end
