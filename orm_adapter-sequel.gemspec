$:.push File.expand_path("../lib", __FILE__)
require "orm_adapter-sequel/version"

Gem::Specification.new do |s|
  s.name = "orm_adapter-sequel"
  s.version = OrmAdapterSequel::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.authors = ["Don Morrison"]
  s.description = "Adds Sequel ORM adapter to the orm_adapter project"
  s.summary = "Adds sequel adapter to orm_adapter which provides a single point of entry for using basic features of popular ruby ORMs."
  s.email = "elskwid@gmail.com"
  s.homepage = "http://github.com/elskwid/orm_adapter-sequel"

  s.rubyforge_project = "orm_adapter-sequel"
  s.required_rubygems_version = ">= 1.3.6"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "activemodel", ">= 3.0.0"
  s.add_dependency "orm_adapter"
  s.add_dependency "sequel", ">= 3.18.0"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "git", ">= 1.2.5"
  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "rspec", ">= 2.4.0"
  s.add_development_dependency "sqlite3-ruby", ">= 1.3.2"
  s.add_development_dependency "yard", ">= 0.6.0"
end