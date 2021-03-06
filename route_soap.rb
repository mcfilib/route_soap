require "contracts"
require "securerandom"

module RouteSoap
  DefaultRouter = Rails.application.routes if defined? Rails

  PathLike = -> (_) do
    _.respond_to?(:required_names) && _.respond_to?(:spec)
  end

  RouteLike = -> (_) do
    _.respond_to?(:defaults) && _.respond_to?(:path) && _.respond_to?(:verb)
  end

  RouterLike = -> (_) do
    _.respond_to?(:routes)
  end

  class Route
    include Contracts

    DEFAULT_BLACKLIST = [
      /\/rails\/info/,
      /\/rails\/info\/properties/,
      /\/rails\/info\/routes/,
    ]

    # Contract RouteLike => Route
    def initialize(route, blacklist = [])
      @route = route
      @blacklist = blacklist + DEFAULT_BLACKLIST
      self
    end

    Contract nil => Bool
    def valid?
      action && controller && verb && !blacklisted? && true || false
    end

    Contract nil => String
    def controller_action
      @controller_action ||= [route.defaults[:controller], route.defaults[:action]].join("#")
    end

    Contract nil => String
    def path
      @path ||= String(route_path.spec).gsub("(.:format)", "").tap do |path|
        required_params.each do |param, value|
          path.gsub!(":#{param}", value) unless param == :format
        end
      end
    end

    Contract nil => Hash
    def required_params
      hash = { format: route.defaults[:format] }.delete_if { |_, v| v.nil? }
      @required_params ||= route_path.required_names.reduce(hash) do |acc, param|
        acc[param] = SecureRandom.hex(3)
        acc
      end
    end

    Contract nil => Symbol
    def verb
      @verb ||= route.verb.downcase.to_sym
    end

    private

    attr_reader :route

    Contract nil => Or[String, nil]
    def action
      route.defaults[:action]
    end

    Contract nil => Bool
    def blacklisted?
      @blacklist.any? { |x| x.match?(path) }
    end

    Contract nil => Or[String, nil]
    def controller
      route.defaults[:controller]
    end

    Contract nil => PathLike
    def route_path
      route.path
    end
  end

  class Spec
    include Contracts

    Contract Route => Spec
    def initialize(route)
      @route = route
      self
    end

    Contract nil => String
    def to_s
      "it { #{ expectation } #{ result } }"
    end

    private

    attr_reader :route

    def expectation
      "expect(#{ route.verb }(\"#{ route.path }\")).to"
    end

    def result
      "route_to(\"#{ route.controller_action }\", #{ route.required_params })"
    end
  end

  class Command
    class << self
      include Contracts

      Contract Or[RouterLike, nil] => nil
      def run!(router = DefaultRouter)
        puts Query.run(router)
      end
    end
  end

  class Query
    class << self
      include Contracts

      # Contract Or[RouterLike, nil] => Array[String]
      def run(router, blacklist)
        Array.new.tap do |lines|
          router.routes.each do |route|
            Route.new(route, blacklist).tap do |simple_route|
              lines << String(Spec.new(simple_route)) if simple_route.valid?
            end
          end
        end
      end
    end
  end
end
