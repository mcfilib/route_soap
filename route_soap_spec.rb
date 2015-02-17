require "route_soap.rb"

describe RouteSoap do
  module RAILS_4_0_3
    class Spec
      def to_s
        "/admin/workspaces/:workspace_id/users/:id(.:format)"
      end
    end

    class Path
      def required_names
        ["workspace_id", "id"]
      end

      def spec
        RAILS_4_0_3::Spec.new
      end
    end

    class Route
      def defaults
        { controller: "admin/users", action: "show" }
      end

      def path
        RAILS_4_0_3::Path.new
      end

      def verb
        /^GET$/
      end
    end

    class Router
      def routes
        [RAILS_4_0_3::Route.new]
      end
    end
  end

  let(:result) do
    "it { expect(get(\"/admin/workspaces/42/users/42\")).to route_to(\"admin/users#show\", {\"workspace_id\"=>\"42\", \"id\"=>\"42\"}) }"
  end

  context "when i have router-like object" do
    describe ".run" do
      it "should be possible to transform it into an array specs" do
        stub_hex!
        expect(RouteSoap::Query.run(RAILS_4_0_3::Router.new)).to eq([result])
      end
    end
  end

  def stub_hex!
    allow(SecureRandom).to receive(:hex).and_return("42")
  end
end
