$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "unitize/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "unitize"
  s.version     = Unitize::VERSION
  s.authors     = ["pinkynrg"]
  s.email       = ["biggyapple@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Unitize."
  s.description = "TODO: Description of Unitize."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.5"

  s.add_development_dependency "sqlite3"
end
