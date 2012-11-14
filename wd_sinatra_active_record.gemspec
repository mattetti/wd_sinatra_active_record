# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wd_sinatra_active_record/version'

Gem::Specification.new do |gem|
  gem.name          = "wd_sinatra_active_record"
  gem.version       = WdSinatraActiveRecord::VERSION
  gem.authors       = ["Matt Aimonetti"]
  gem.email         = ["mattaimonetti@gmail.com"]
  gem.description   = %q{Basics to use ActiveRecord with WD Sinatra.}
  gem.summary       = %q{Provides a way to get started with ActiveRecord and WeaselDiesel on Sinatra.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activerecord"
end
