# encoding: UTF-8
# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "mobilepronto/version"
begin
  require "step-up"
rescue Exception => e; end

gf = File.expand_path("../GEM_VERSION", __FILE__)
File.delete(gf) if File.exists?(gf)

Gem::Specification.new do |s|
  s.name          = "mobilepronto"
  s.version       = MobilePronto::VERSION.to_s
  s.platform      = Gem::Platform::RUBY
  s.summary       = "A Ruby interface to the MobilePronto SMS gateway API."
  s.require_paths = ['lib']
  s.files         = Dir["{lib/**/*.rb,GEM_VERSION,README.md}"]

  s.author        = "Éverton A. Ribeiro"
  s.email         = "nuxlli@gmail.com.br"
  s.homepage      = "http://github.com/nuxlli/mobilepronto"
  
  s.add_dependency "activesupport"

  s.add_development_dependency "webmock"
  s.add_development_dependency "minitest"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "step-up", "~> 0.7.0"
end
