# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utilities/version'

Gem::Specification.new do |spec|
  spec.name          = "utilities"
  spec.version       = Utilities::VERSION
  spec.authors       = ["Brian Brotherton"]
  spec.email         = ["brian.brotherton@gmail.com"]
  spec.summary       = "A collection of modules that provide utility functions or class behaviors that I typically use in my projects"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) } #`git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'log4r'
  spec.add_dependency 'configliere'
end
