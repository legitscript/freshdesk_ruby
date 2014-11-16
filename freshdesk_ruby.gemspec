require File.expand_path('./lib/freshdesk_ruby/version')

Gem::Specification.new do |gem|
  gem.name        = 'freshdesk_ruby'
  gem.version     = Freshdesk::VERSION
  gem.license     = 'MIT'
  gem.summary     = 'A Ruby wrapper to the Freshdesk API.'
  gem.description = 'A Ruby wrapper to the Freshdesk API.'
  gem.authors     = ['Harper Henn']
  gem.email       = 'harper.henn@legitscript.com'
  gem.files       = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.test_files  = gem.files.grep(/^spec/)
  gem.homepage    = 'https://github.com/legitscript/freshdesk_ruby'

  gem.add_runtime_dependency 'httpclient'
  gem.add_runtime_dependency 'activesupport'

  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'pry'
end
