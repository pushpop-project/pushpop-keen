# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'pushpop-keen/version'

Gem::Specification.new do |s|

  s.name        = "pushpop-keen"
  s.version     = Pushpop::Keen::VERSION
  s.authors     = ["Josh Dzielak"]
  s.email       = "josh@keen.io"
  s.homepage    = "https://github.com/pushpop-project/pushpop-keen"
  s.summary     = "Pushpop Keen IO plugin for querying and recording events"

  s.add_dependency "pushpop"
  s.add_dependency "keen"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

