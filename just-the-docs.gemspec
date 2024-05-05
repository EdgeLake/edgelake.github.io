# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "edgelake-specs"
  spec.version       = "1.0.0"
  spec.authors       = ["Ori Shadmon"]
  spec.email         = ["ori@anylog.co"]

  spec.summary       = %q{EdgeLake documentation}
  spec.homepage      = "https://github.com/EdgeLake/edgeLake.github.io"
  spec.license       = "MIT"
  spec.metadata      = {
    "bug_tracker_uri"   => "https://github.com/EdgeLake/edgeLake.github.io/issues",
    "documentation_uri" => "https://edgeLake.github.io",
    "source_code_uri"   => "https://github.com/EdgeLake/edgeLake.github.io",
  }

  spec.files         = `git ls-files -z ':!:*.jpg' ':!:*.png'`.split("\x0").select { |f| f.match(%r{^(assets|bin|_layouts|_includes|lib|Rakefile|_sass|LICENSE|README|CHANGELOG|favicon)}i) }
  spec.executables   << 'just-the-docs'

  spec.add_development_dependency "bundler", ">= 2.3.5"
  spec.add_runtime_dependency "jekyll", ">= 3.8.5"
  spec.add_runtime_dependency "jekyll-seo-tag", ">= 2.0"
  spec.add_runtime_dependency "jekyll-include-cache"
  spec.add_runtime_dependency "rake", ">= 12.3.1"
end
