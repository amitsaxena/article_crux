# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'article_crux/version'

Gem::Specification.new do |spec|
  spec.name          = "article_crux"
  spec.version       = ArticleCrux::VERSION
  spec.authors       = ["amitsaxena"]
  spec.email         = ["amit83.saxena@gmail.com"]

  spec.summary       = %q{Returns crux of an article, which includes title and the most likely image that represents the article}
  spec.description   = %q{The gem scrapes HTML of a URL to return the title and cover image which most likey represents the article. It also returns an array of tags.}
  spec.homepage      = "https://github.com/amitsaxena/article_crux"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "fastimage", "~> 2.0"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "httparty", "~> 0.12"
  spec.add_dependency 'addressable', "~> 2.3"
end
