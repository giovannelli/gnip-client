# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnip'

Gem::Specification.new do |spec|
  spec.name          = "gnip-client"
  spec.version       = Gnip::VERSION
  spec.authors       = ["Duccio Giovannelli"]
  spec.email         = ["giovannelli@extendi.it"]

  spec.summary       = %q{A Ruby library for accessing the Gnip API. See https://gnip.com/ for full details and to sign up for an account.}
  spec.homepage      = "https://github.com/giovannelli/gnip"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  
  spec.add_dependency 'httparty', '>= 0'
  spec.add_dependency 'em-http-request', '>= 1.0.3'  
  spec.add_dependency 'activesupport', '>= 4.2.1'
end
