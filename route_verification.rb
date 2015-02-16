require "contracts"

module RouteVerification
  PathLike = -> (_) do
    _.respond_to?(:required_names) && _.respond_to?(:spec)
  end

  RouteLike = -> (_) do
    _.respond_to?(:path)
  end

  RouterLike = -> (_) do
    _.respond_to?(:routes)
  end

  class Route
    include Contracts

    BLACKLIST = [
      "/",
      "/prototypes/*id",
      "/rails/info",
      "/rails/info/properties",
      "/rails/info/routes"
    ]

    VERBS = {
      /^DELETE$/ => :delete,
      /^GET$/    => :get,
      /^PATCH$/  => :patch,
      /^POST$/   => :post,
      /^PUT$/    => :put
    }

    Contract RouteLike => Route
    def initialize(route)
      @route = route
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
          path.gsub!(":#{param}", value)
        end
      end
    end

    Contract nil => Hash
    def required_params
      @required_params ||= route_path.required_names.reduce(Hash.new) do |acc, param|
        acc[param] = SecureRandom.hex(3)
        acc
      end
    end

    Contract nil => Symbol
    def verb
      @verb ||= VERBS[route.verb]
    end

    private

    attr_reader :route

    Contract nil => Or[String, nil]
    def action
      route.defaults[:action]
    end

    Contract nil => Bool
    def blacklisted?
      BLACKLIST.include?(path)
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

    Contract RouteLike => Spec
    def initialize(route)
      @route = route
      self
    end

    Contract nil => String
    def to_s
      "it { expect(#{ route.verb }(\"#{ route.path }\")).to route_to(\"#{ route.controller_action }\", #{ route.required_params }) }"
    end

    private

    attr_reader :route
  end

  class Command
    class << self
      include Contracts

      Contract Or[RouterLike, nil] => Array[String]
      def run(router = Rails.application.routes)
        Array.new.tap do |lines|
          router.routes.each do |route|
            Route.new(route).tap do |simple_route|
              lines << String(Spec.new(simple_route)) if simple_route.valid?
            end
          end
        end
      end

      Contract Or[RouterLike, nil] => nil
      def run!(router = Rails.application.routes)
        puts run(router)
      end
    end
  end
end
