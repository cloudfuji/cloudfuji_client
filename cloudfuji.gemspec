# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudfuji/version"

Gem::Specification.new do |s|
  s.name        = "cloudfuji"
  s.version     = Cloudfuji::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sean Grove", "Kev Zettler"]
  s.email       = ["support@cloudfuji.com","s@bushi.do", "k@bushi.do"]
  s.homepage    = "https://github.com/cloudfuji/cloudfuji_client"
  s.summary     = %q{Cloudfuji integration}
  s.description = %q{A module for integrating the Cloudfuji platform into a ruby app}

  s.add_dependency "rest-client", ">=1.6.1"
  s.add_dependency "json",        ">=1.4.6"
  s.add_dependency "highline",    ">=1.6.1"
  s.add_dependency "orm_adapter", "~> 0.0.3"

  s.rubyforge_project = "cloudfuji"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,test_app,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
