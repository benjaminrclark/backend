# -*- encoding: utf-8 -*-

require 'rake'

Gem::Specification.new do |gem|
  # Meta data

  gem.name        = 'backend'
  gem.version     = '1.0' 
  gem.summary     = 'Backend Application'
  gem.description = 'This doesnt really do anything'
  gem.homepage    = 'http://example.com'
  gem.license     = 'CLOSED SOURCE'

  gem.authors     = [
    'benjamin.r.clark',
  ]

  gem.email = [
    'benjamin.r.clark@gmail.com'
  ]


  gem.files = FileList[
    'app.rb'
  ]

  gem.test_files    = FileList['spec/**/*']

  gem.require_paths = ['lib']

  # Development dependencies

  gem.add_development_dependency 'rake', '< 11.0'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-its'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'shoulda-matchers', '~> 3.1'
  gem.add_development_dependency 'simplecov', '>= 0.8.2'
  gem.add_development_dependency 'uuidtools'
  gem.add_development_dependency 'yard'

  # Runtime dependencies

  gem.add_dependency 'active_record_migrations'
  gem.add_dependency 'activerecord',       '>= 4.2.5'
  gem.add_dependency 'activesupport',      '>= 4.2.5'
  gem.add_dependency 'json'
  gem.add_dependency 'pony'
  gem.add_dependency 'pg'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'sinatra-contrib'
  gem.add_dependency 'sinatra-flash'
  gem.add_dependency 'sinatra-param'
  gem.add_dependency 'sunspot_rails'
  gem.add_dependency 'sunspot_solr'
  gem.add_dependency 'typhoeus'
  gem.add_dependency 'unicorn' 
  gem.add_dependency 'will_paginate', '~> 3.0.6'
  gem.add_dependency 'will_paginate-bootstrap'
  gem.add_dependency 'yell'
  gem.add_dependency 'yell-adapters-syslog'
end
