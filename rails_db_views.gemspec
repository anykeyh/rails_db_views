$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_db_views/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_db_views"
  s.version     = RailsDbViews::VERSION
  s.authors     = ["Yacine Petitprez"]
  s.email       = ["anykeyh@gmail.com"]
  s.homepage    = "https://github.com/anykeyh/rails_db_views"
  s.summary     = "Provide tools to create and manage database view through Rails project."
  s.description = "You want to use advanced tools into your database but Ruby On Rails is not made for it?
    We provide here the answer creating views as virtual models and managing functions"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]

  s.add_dependency "rails", ">= 4.0"
  s.add_runtime_dependency "rake-hooks", '~> 1.2', '>= 1.2.3'

  s.add_development_dependency 'pg', '~> 0.18'
end
