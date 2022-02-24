spec = Gem::Specification.new do |s|
  s.name    = "habaki"
  s.version = "0.2.0"
  s.summary = "CSS parser/writer"
  s.author  = "Julien Boulnois"
  s.license = "MIT"
  s.homepage = "https://github.com/immateriel/habaki"

  s.extensions = "ext/katana/extconf.rb"
  s.required_ruby_version = ">= 2.4"

  s.files = ["Gemfile"] +
            Dir.glob("ext/**/*.{c,h,rb}") +
            Dir.glob("lib/**/*.{rb}")

  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.14"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "ruby-prof"
end
