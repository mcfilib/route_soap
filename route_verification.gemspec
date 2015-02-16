Gem::Specification.new do |spec|
  spec.name                  = "route_verification"
  spec.version               = "0.0.1"
  spec.required_ruby_version = ">= 1.9.3"
  spec.authors               = ["Philip Cunningham"]
  spec.email                 = ["hello@filib.io"]
  spec.description           = "Generate route specs"
  spec.summary               = "A microgem to generate specs based on your routes."
  spec.homepage              = "https://gist.github.com/filib/ee6c0c01169e14d1b5bc"
  spec.license               = "MIT"
  spec.files                 = ["route_verification.rb"]
  spec.require_path          = "."
  spec.test_file             = "route_verification_spec.rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency     "contracts", "~> 0.4"
end
