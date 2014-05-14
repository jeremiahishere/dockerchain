# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerchain/version'

Gem::Specification.new do |spec|
  spec.name          = 'dockerchain'
  spec.version       = Dockerchain::VERSION
  spec.authors       = ['Adam Dunson']
  spec.email         = ['adam@cloudspace.com']
  spec.summary       = %q{Run a series of dockerfiles, chaining the output of one into the next}
  spec.description   = %q{Run a series of dockerfiles, chaining the output of one into the next}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'dockerfile_ast'
end
