# -*- encoding: utf-8 -*-
require File.expand_path('../lib/file_name/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kyoendo"]
  gem.email         = ["postagie@gmail.com"]
  gem.description   = %q{add functionality to string for handling filenames.}
  gem.summary       = %q{FileName is a module which can add functionality to string for handling filenames.}
  gem.homepage      = "https://github.com/melborne/filename"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "file_name"
  gem.require_paths = ["lib"]
  gem.version       = Filename::VERSION
  gem.required_ruby_version = '>=1.9.2'
end
