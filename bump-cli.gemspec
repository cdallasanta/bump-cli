
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bump-cli/version"

Gem::Specification.new do |spec|
  spec.name          = "bump-cli"
  spec.version       = BumpCli::VERSION
  spec.authors       = ["'Chris Dalla Santa'"]
  spec.email         = ["'chris.dallasanta@gmail.com'"]

  spec.summary       = %q{This Ruby Gem provides a CLI to view articles from www.thebump.com}
  spec.homepage      = "https://github.com/cdallasanta/bump-cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/cdallasanta/bump-cli"
    spec.metadata["changelog_uri"] = "https://github.com/cdallasanta/bump-cli/blob/master/README.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = ['lib/article.rb','lib/bump-cli.rb','lib/cli.rb','lib/scraper.rb', 'config/environment.rb']
  spec.bindir        = "bin"
  spec.executables   << 'bump-cli'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", ">= 0"
  spec.add_dependency "nokogiri", ">= 0"
  spec.add_dependency "colorize", ">= 0"
end
