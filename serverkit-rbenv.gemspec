lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "serverkit/defaults/version"

Gem::Specification.new do |spec|
  spec.name          = "serverkit-defaults"
  spec.version       = Serverkit::Defaults::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Serverkit plug-in for defaults(1) of Mac OS X."
  spec.homepage      = "https://github.com/r7kamura/serverkit-defaults"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "plist"
  spec.add_runtime_dependency "serverkit"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
