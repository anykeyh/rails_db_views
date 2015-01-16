$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_db_view/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-db-view"
  s.version     = RailsDbView::VERSION
  s.authors     = ["Yacine Petitprez"]
  s.email       = ["anykeyh@gmail.com"]
  s.homepage    = "https://github.com/anykeyh/rails-db-view"
  s.summary     = "Provide tools to create and manage database view through Rails project."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency "rake-hooks"

  s.add_development_dependency "sqlite3"
end
