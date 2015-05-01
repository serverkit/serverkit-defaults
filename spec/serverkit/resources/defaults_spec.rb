require "spec_helper"

RSpec.describe Serverkit::Resources::Defaults do
  describe "#apply" do
    let(:recipe) { Serverkit::Recipe.new({}) }

    context "with Array #value" do
      let(:key) { "persistent-apps" }
      let(:attributes) { { "key" => key, "value" => [] } }
      let(:resource) { described_class.new(recipe, attributes) }
      let(:command) do
        "defaults  write #{described_class::DEFAULT_DOMAIN} #{key}  \\(\\)"
      end

      it "runs the correct command" do
        expect(resource).to receive(:run_command).with(command)

        resource.apply
      end
    end

    context "with #type_option passed" do
      let(:key) { "com.apple.keyboard.modifiermapping.1452-601-0" }
      let(:value) { "<dict><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>" }
      let(:type_option) { "-array" }
      let(:attributes) { { "key" => key, "type_option" => type_option, "value" => value } }
      let(:resource) { described_class.new(recipe, attributes) }
      let(:command) do
        "defaults  write #{described_class::DEFAULT_DOMAIN} #{key} #{type_option} '#{value}'"
      end

      it "runs the correct command" do
        expect(resource).to receive(:run_command).with(command)

        resource.apply
      end
    end

    context 'with #host passed as "current"' do
      let(:key) { "key" }
      let(:attributes) { { "host" => "current", "key" => key, "value" => [] } }
      let(:resource) { described_class.new(recipe, attributes) }
      let(:command) do
        "defaults -currentHost write #{described_class::DEFAULT_DOMAIN} #{key}  \\(\\)"
      end

      it "runs the correct command" do
        expect(resource).to receive(:run_command).with(command)

        resource.apply
      end
    end

    context 'with #host passed' do
      let(:key) { "key" }
      let(:host) { "takehiro" }
      let(:attributes) { { "host" => host, "key" => key, "value" => [] } }
      let(:resource) { described_class.new(recipe, attributes) }
      let(:command) do
        "defaults -host #{host} write #{described_class::DEFAULT_DOMAIN} #{key}  \\(\\)"
      end

      it "runs the correct command" do
        expect(resource).to receive(:run_command).with(command)

        resource.apply
      end
    end
  end
end
