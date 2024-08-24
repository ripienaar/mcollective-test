spec = Gem::Specification.new do |s|
  s.name = "mcollective-test"
  s.version = "0.5.0"
  s.author = "R.I.Pienaar"
  s.email = "rip@devco.net"
  s.homepage = "https://github.com/ripienaar/mcollective-test/"
  s.summary = "Test helper for MCollective"
  s.description = "Helpers, matchers and other utilities for writing agent, application and integration tests"
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.require_path = "lib"
end
