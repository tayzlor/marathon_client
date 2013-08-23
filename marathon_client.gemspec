# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marathon/version'

Gem::Specification.new do |spec|
  spec.name          = "marathon_client"
  spec.version       = Marathon::VERSION
  spec.authors       = ["Tobi Knaup"]
  spec.email         = ["tobi@knaup.me"]
  spec.description   = %q{Command line client for the Marathon scheduler. Marathon is a Mesos scheduler for long running services.}
  spec.summary       = %q{Command line client for the Marathon scheduler.}
  spec.homepage      = "http://www.mesosphe.re"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "trollop", "~> 2.0"
  spec.add_dependency "httparty", "~> 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
