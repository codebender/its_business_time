$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "its_business_time/version"

Gem::Specification.new do |s|
  s.name = "its_business_time"
  s.version = ItsBusinessTime::VERSION
  s.summary = "The business_time gem, but only with what I want"
  s.description = "Easily configures the business hours and timezone of your business and extends Time & Date instances with goodies"
  s.homepage = "https://github.com/codebender/its_business_time"
  s.authors = ["codebender"]
  s.email = "matt@blinker.com"
  s.license = "MIT"

  s.files = `git ls-files -- {lib,rails_generators,LICENSE,README.md}`.split("\n")

  s.add_dependency('activesupport','>= 3.2.0')

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "pry"
end
