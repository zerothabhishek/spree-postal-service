# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'spree_postal_service/version'

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_postal_service'
  s.version      = SpreePostalService::VERSION
  s.summary      = 'Calculate weight based charges for a Spree order'
  s.description  = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author       = 'Torsten Rüger'
  s.email        = 'torsten@villataika.fi'
  s.homepage     = 'https://github.com/dancinglightning/spree-postal-service'
  s.license      = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = false

  s.add_runtime_dependency 'spree_core', '~> 2.0'

  s.add_development_dependency 'i18n', '~> 0.6.1'
  s.add_development_dependency 'rails-i18n', '~> 0.7.3'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'sqlite3', '~> 1.3.7'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'i18n-spec', '~> 0.4.0'
  s.add_development_dependency 'fuubar', '>= 0.0.1'
  s.add_development_dependency 'pry-rails'
end
