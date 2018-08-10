$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "unitize/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "unitize"
  s.version     = Unitize::VERSION
  s.authors     = ["pinkynrg"]
  s.email       = ["biggyapple@gmail.com"]
  s.homepage    = "http://www.francescomeli.com"
  s.summary     = "A db based gem for all measurement units"
  s.description = "Unitize is gem for Rails inspired by the marvelous Unitwise gem, with the only expection that all measurement units are saved on your database. Do you have a weird non-linear measurement unit conversion that you want to add to your collection at runtime? With Unitize you can!"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency               'rails',             '~> 5'
  s.add_dependency               'liner',             '~> 0.2'
  s.add_dependency               'signed_multiset',   '~> 0.2'
  s.add_dependency               'memoizable',        '~> 0.4'
  s.add_dependency               'parslet',           '~> 1.5'
  s.add_dependency               'dentaku',           '~> 2.0.11'

  s.add_development_dependency   'factory_girl'
  s.add_development_dependency   'byebug'
  s.add_development_dependency   'nokogiri',          '~> 1.8.2'
  s.add_development_dependency   'pry',               '~> 0.9'
  s.add_development_dependency   'minitest',          '~> 5.0'
  s.add_development_dependency   'rake',              '~> 10.0'
  s.add_development_dependency   'nori',              '~> 2.3'

  s.add_development_dependency   'sqlite3'
end
