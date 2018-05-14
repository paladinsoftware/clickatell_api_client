# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "clickatell_api_client/version"

Gem::Specification.new do |spec|
  spec.name          = "clickatell_api_client"
  spec.version       = ClickatellApiClient::VERSION
  spec.authors       = ["Piotr Jaworski"]
  spec.email         = ["piotrek.jaw@gmail.com"]

  spec.summary       = %q{Clickatell API Ruby wrapper.}
  spec.description   = %q{Gem which is a wrapper written in Ruby for Clickatell API.}
  spec.homepage      = "https://github.com/paladinsoftware/clickatell_api_client"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", ">= 0.7"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
