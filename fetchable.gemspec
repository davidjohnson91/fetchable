# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetchable/version'

Gem::Specification.new do |spec|
  spec.name          = "fetchable"
  spec.version       = Fetchable::VERSION
  spec.authors       = ["David Johnson"]
  spec.email         = ["david@davidjohnson.me"]
  spec.summary       = %q{The missing ActiveRecord for APIs.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
