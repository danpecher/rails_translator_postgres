$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_translator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_translator"
  s.version     = RailsTranslator::VERSION
  s.authors     = ["Dan Pecher"]
  s.email       = ["dan.pecher@gmail.com"]
  s.homepage    = "http://github.com/danpecher/rails-translator/"
  s.summary     = "Summary of RailsTranslator."
  s.description = "Description of RailsTranslator."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_dependency 'pg'

  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'will_paginate'
  s.add_dependency 'will_paginate-bootstrap'

  s.add_development_dependency "sqlite3"
end
