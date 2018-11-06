lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "eucalypt/version"

Gem::Specification.new do |spec|
  spec.name          = "eucalypt"
  spec.version       = Eucalypt::VERSION
  spec.authors       = ["Edwin Onuonga"]
  spec.email         = ["edwinonuonga@gmail.com"]

  spec.summary       = %q{Micro-framework and CLI wrapped around the Sinatra DSL.}
  spec.homepage      = "https://eucalypt.gitbook.io/eucalypt"
  spec.license       = "MIT"
  spec.files         = Dir.glob('lib/**/*', File::FNM_DOTMATCH) + %w[Gemfile LICENSE README.md Rakefile eucalypt.gemspec bin/eucalypt]
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f)}
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.5"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "regexp-examples", "~> 1.4"
  spec.add_development_dependency "colorize", "~> 0.8"

  spec.add_runtime_dependency "string-builder", "~> 2.3"
  spec.add_runtime_dependency "activesupport", "~> 5.2"
  spec.add_runtime_dependency "activerecord", "~> 5.2"
  spec.add_runtime_dependency "front_matter_parser", "0.2.0"
  spec.add_runtime_dependency "thor", "~> 0.20"
  spec.add_runtime_dependency "sinatra", "~> 2.0", ">= 2.0.4"
  spec.add_runtime_dependency "rerun", "~> 0.13"

  spec.metadata = {
    "documentation_uri" => "https://eucalypt.gitbook.io/eucalypt",
    "source_code_uri"   => "https://github.com/eucalypt-framework/eucalypt/"
  }
end
