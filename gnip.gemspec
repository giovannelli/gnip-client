# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnip/version'

Gem::Specification.new do |spec|
  spec.name          = 'gnip-client'
  spec.version       = Gnip::VERSION
  spec.authors       = ['Duccio Giovannelli']
  spec.email         = ['giovannelli@extendi.it']

  spec.summary       = 'A Ruby library for accessing the Gnip API. See https://gnip.com/ for full details and to sign up for an account.'
  spec.homepage      = 'https://github.com/giovannelli/gnip-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_dependency 'em-http-request', '~> 1'
  spec.add_dependency 'httparty', '~> 0.16'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3'

end
