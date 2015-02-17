Gem::Specification.new do |spec|
  spec.name                  = "route_soap"
  spec.version               = "0.0.1"
  spec.required_ruby_version = ">= 1.9.3"
  spec.authors               = ["Philip Cunningham"]
  spec.email                 = ["hello@filib.io"]
  spec.description           = "Route spec generator"
  spec.summary               = "A little gem to assist you in keeping your routes clean."
  spec.homepage              = "https://github.com/filib/route_soap"
  spec.license               = "MIT"
  spec.files                 = ["route_soap.rb"]
  spec.require_path          = "."
  spec.test_file             = "route_soap_spec.rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency     "contracts", ">= 0.4", "< 0.6"
end
