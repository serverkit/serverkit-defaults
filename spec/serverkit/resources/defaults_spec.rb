require "spec_helper"

RSpec.describe Serverkit::Resources::Defaults do
  describe "#apply" do
    context "with Array #value" do
      let(:recipe) { Serverkit::Recipe.new({}) }
      let(:key) { "persistent-apps" }
      let(:attributes) { { "key" => key, "value" => [] } }
      let(:resource) { described_class.new(recipe, attributes) }
      let(:command) do
        "defaults write #{described_class::DEFAULT_DOMAIN} #{key}  \\(\\)"
      end

      it "runs the correct command" do
        expect(resource).to receive(:run_command).with(command)

        resource.apply
      end
    end
  end
end
