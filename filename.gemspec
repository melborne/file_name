# -*- encoding: utf-8 -*-
require File.expand_path('../lib/filename/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kyoendo"]
  gem.email         = ["postagie@gmail.com"]
  gem.description   = %q{Utility for handling filename strings.}
  gem.summary       = %q{FileName is a utility for handling filename strings which can be alternative of some File class methods. }
  gem.homepage      = "https://github.com/melborne/filename"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "filename"
  gem.require_paths = ["lib"]
  gem.version       = Filename::VERSION
  gem.required_ruby_version = '>=1.9.2'
end
