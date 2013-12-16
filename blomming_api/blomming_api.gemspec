# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blomming_api/version'

Gem::Specification.new do |spec|
  spec.name          = "blomming_api"
  spec.version       = BlommingApi::VERSION
  spec.authors       = ["Giorgio Robino"]
  spec.email         = ["giorgio.robino@gmail.com"]
  spec.description   = %q{www.blomming.com social commerce API's wrapper: supply a client access layer that embed authentication and communication details, supply API endpoints wrappers.}
  spec.summary       = %q{www.blomming.com social commerce API's wrapper}
  spec.homepage      = "https://github.com/solyaris/blomming_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # dipendenze applicative da altre gemme, in runtime 
  spec.add_runtime_dependency "rest-client" 
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "oj"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end