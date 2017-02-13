# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convers_money/version'

Gem::Specification.new do |spec|
  spec.name          = 'convers_money'
  spec.version       = ConversMoney::VERSION
  spec.authors       = ['Toño Serna']
  spec.email         = ['antonelo@gmail.com']

  spec.summary       = 'Money conversor'
  spec.description   = "ConversMoney it's a Money Conversor given by fixed currency and change rates of your choice. \r\n From the version and further '1.0.1' it's a full working version"
  spec.homepage      = 'https://github.com/nelantone/convers_money'
  spec.license       = 'MIT'


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5', '>= 3.5'
  spec.add_development_dependency 'guard', '~> 2.14', '>= 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.0', '>= 4.6.0'
end
