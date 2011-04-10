# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "muxilla/version"

Gem::Specification.new do |s|
  s.name        = "muxilla"
  s.version     = Muxilla::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Chris Apolzon']
  s.email       = ['apolzon@gmail.com']
  s.homepage    = ""
  s.summary     = %q{Quickly create story-specific tmux scripts}
  s.description = %q{A prompt-based cli to generate a tmux script based on the story name and related systems}

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'fuubar'

  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'json'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
