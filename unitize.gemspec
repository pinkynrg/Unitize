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

  s.add_dependency               'rails',           '~> 5.0.2'
  s.add_dependency               'liner',           '~> 0.2'
  s.add_dependency               'signed_multiset', '~> 0.2'
  s.add_dependency               'memoizable',      '~> 0.4'
  s.add_dependency               'parslet',         '~> 1.5'

  s.add_development_dependency   'nokogiri',        '~> 1.5'
  s.add_development_dependency   'pry',             '~> 0.9'
  s.add_development_dependency   'minitest',        '~> 5.0'
  s.add_development_dependency   'rake',            '~> 10.0'
  s.add_development_dependency   'nori',            '~> 2.3'

  s.add_development_dependency "sqlite3"
end
