# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cellular/version'

Gem::Specification.new do |gem|
  gem.name          = 'cellular'
  gem.version       = Cellular::VERSION
  gem.authors       = ['Sindre Moen', 'Tim Kurvers']
  gem.email         = ['ruby@hyper.no']
  gem.description   = 'Sending and receiving SMSs through pluggable backends'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/hyperoslo/cellular'

  gem.files         = `git ls-files`.split($/)
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'httparty', '~> 0.13'
  gem.add_dependency 'savon',    '~> 2.0'

  # FIXME: Move us to development dependencies.
  gem.add_dependency 'activejob', '>= 4.2'
  gem.add_dependency 'activesupport', '>= 4.2'

  gem.add_development_dependency 'rake', '~> 12.0'
  gem.add_development_dependency 'rspec', '~> 3.6'
  gem.add_development_dependency 'webmock', '~> 2.3'

  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'simplecov', '~> 0.9'
end
