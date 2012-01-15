# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/shopify/version"

Gem::Specification.new do |s|
  s.name        = "guard-shopify"
  s.version     = Guard::ShopifyVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonan Scheffler"]
  s.email       = ["jonanscheffler+rubygems@gmail.com"]
  s.homepage    = "https://github.com/1337807/guard-shopify"
  s.summary     = "Gem to upload Shopify template modifications."
  s.description     = %q{This gem allows guard to watch a Shopify template directory for changes and then upload them immediately to Shopify using their API.}

  s.rubyforge_project = "guard-shopify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '>= 0.10.0'
  s.add_dependency 'shopify_api', '~> 2.2.0'
  s.add_dependency 'ptools', '~> 1.2.1'

  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'guard-rspec', '~> 0.6.0'
end
