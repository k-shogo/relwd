# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spinel/version'

Gem::Specification.new do |spec|
  spec.name          = "spinel"
  spec.version       = Spinel::VERSION
  spec.authors       = ["k-shogo"]
  spec.email         = ["platycod0n.ramosa@gmail.com"]
  spec.summary       = %q{lightweight text search system on Redis}
  spec.description   = %q{lightweight text search system on Redis}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'redis', '>= 3.0'
  spec.add_dependency 'multi_json', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", ">= 5.4"
  spec.add_development_dependency "minitest-power_assert"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "mock_redis"
end
