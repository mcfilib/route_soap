# route_soap

> Now you strike me as a person who has only one thing on their mind. You're
> saying to yourself, "Why do I need another all-purpose cleanser?"

![](route_soap.gif)

A little gem to assist you in keeping your routes clean.

# Installation

Add this line to your application's Gemfile:

```
gem 'route_soap'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install route_soap
```

## Usage

This gem provides four abstractions.

### `RouteSoap::Route`

This is the an adapter around `ActionDispatch::Journey::Route` to provide a
smaller API.

### `RouteSoap::Spec`

This takes an instance of `RouteSoap::Route` and creates an `rspec` expectation.
If you want to extend the gem to work with other testing frameworks you'll have
to create an object with the same API.

### `RouteSoap::Query`

This takes a router and returns an array of expectations.

### `RouteSoap::Command`

This takes a router and outputs array of expectations to the console.

### Example

``` ruby
task generate_route_specs: :environment do
  File.open("spec/routing/all_routes_spec.rb", "w") do |file|
    file.puts("require 'unit_helper'")
    file.puts
    file.puts("describe 'All Routes' do")
    RouteSoap::Query.run.each do |spec|
      file.puts(["  ",  spec].join(""))
    end
    file.puts("end")
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
