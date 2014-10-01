# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cellular/version'

Gem::Specification.new do |gem|
  gem.name          = 'cellular'
  gem.version       = Cellular::VERSION
  gem.authors       = ['Sindre Moen', 'Tim Kurvers']
  gem.email         = ['johannes@hyper.no']
  gem.description   = %q{Sending and receiving SMSs through pluggable backends}
  gem.summary       = %q{Sending and receiving SMSs through pluggable backends}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'httparty', '~> 0.13.0'
  gem.add_dependency 'savon',    '~> 2.0'

  gem.add_development_dependency 'pry', '~> 0.10'

  gem.add_development_dependency 'guard', '~> 2.6'
  gem.add_development_dependency 'guard-rspec', '~> 4.3'
  gem.add_development_dependency 'rake', '~> 10.3'
  gem.add_development_dependency 'webmock', '~> 1.19'

  gem.add_development_dependency 'sidekiq', '~> 3.2'

  gem.add_development_dependency 'rspec-rails', '~> 2.99'

  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'simplecov', '~> 0.9'
end
