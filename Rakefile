require 'rubygems'
require 'rake/gempackagetask'
require 'rspec/core/rake_task'

spec = Gem::Specification.new do |s|
  s.name = "mcollective-test"
  s.version = "0.1.3"
  s.author = "R.I.Pienaar"
  s.email = "rip@devco.net"
  s.homepage = "https://github.com/ripienaar/mcollective-test/"
  s.summary = "Test helper for MCollective"
  s.description = "Helpers, matchers and other utilities for writing agent, application and integration tests"
  s.files = FileList["lib/**/*"].to_a
  s.require_path = "lib"
  s.has_rdoc = false
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => :repackage
