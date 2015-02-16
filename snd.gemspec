# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'snd'
  s.version     = '0.0.1'
  s.date        = '2015-02-16'
  s.executables = %w(snd)


  s.summary     = 'A dashboard for Tomcat applications so simple it just takes one neuron to configure'
  s.description = ''
  s.author      = 'Daniel Gil & Pablo Serrano'
  s.email       = 'daniel.gil.bayo@gmail.com'
  s.homepage    = 'https://github.com/danielgil/single-neuron-dashboard'

  s.files = Dir['README.md', 'javascripts/**/*', 'templates/**/*','templates/**/.[a-z]*', 'lib/**/*']

  s.add_dependency('sinatra')
  s.add_dependency('sinatra-contrib')
  s.add_dependency('thin')
  s.add_dependency('rack')
  s.add_dependency('thor')

  s.add_development_dependency('rake')
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('haml')
  s.add_development_dependency('minitest')
  s.add_development_dependency('json')
end