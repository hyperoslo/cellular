# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cellular/version'

Gem::Specification.new do |gem|
  gem.name          = 'cellular'
  gem.version       = Cellular::VERSION
  gem.authors       = ['Tim Kurvers']
  gem.email         = ['tim@moonsphere.net']
  gem.description   = %q{Sending and receiving SMSs through pluggable backends}
  gem.summary       = %q{Sending and receiving SMSs through pluggable backends}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'savon', '~> 2.0'

  gem.add_development_dependency 'pry'
end
