# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rt_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'rt_api'
  spec.version       = RTApi::VERSION
  spec.authors       = ['Kryptyk Fysh']
  spec.email         = ['kryptykfysh@kryptykfysh.co.uk']
  spec.summary       = %q{A Ruby wrapper for the RT ticketing API interface.}
  spec.description   = File.read('README.md')
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |x| x =~ /\A.*\.gem\z/i }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.5', '>= 4.5.0'
  spec.add_development_dependency 'guard-cucumber', '~> 1.5', '>= 1.5.3'
  spec.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.1'
  spec.add_development_dependency 'libnotify', '~>  0.9', '>= 0.9.1'

  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.0'
  spec.add_runtime_dependency 'rest-client', '~> 1.7', '>= 1.7.2'
end
