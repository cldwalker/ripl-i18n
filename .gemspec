# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/ripl/i18n/version"

Gem::Specification.new do |s|
  s.name        = "ripl-i18n"
  s.version     = Ripl::I18n::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/ripl-i18n"
  s.summary = "A ripl plugin que habla ta langue"
  s.description =  "A ripl plugin that translates ripl to your preferred language."
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'tagaholic'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.files += Dir.glob(['lib/ripl/i18n/locales/*.yml', 'test/fixtures/{,*}.yml'])
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
