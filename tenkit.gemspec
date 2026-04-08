# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "tenkit/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "tenkit"
  s.version = Tenkit::VERSION
  s.required_ruby_version = ">= 3.2"
  s.summary = "Wrapper for WeatherKit API"
  s.description = "Wrapper for Weatherkit API"
  s.author = "James Pierce"
  s.email = "james@superbasic.xyz"
  s.homepage = "https://github.com/superbasicxyz/tenkit"
  s.license = "MIT"
  s.files = Dir["lib/tenkit.rb", "lib/**/*.rb"]

  s.metadata["rubygems_mfa_required"] = "true"

  s.add_dependency "httparty", "~> 0.24.0"
  s.add_dependency "jwt", "~> 3.0"
end
