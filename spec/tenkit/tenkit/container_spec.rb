require_relative "../spec_helper"
RSpec.describe Tenkit::Container do
  subject(:container) { described_class.new(payload) }

  let(:node) { {"someKey" => "someValue"} }

  describe "initializer" do
    context "when passed a hash" do
      let(:payload) { {"rootHash" => {"someArray" => [node, node], "someHash" => node}} }

      it "returns an object with converted attributes" do
        aggregate_failures do
          expect(container.root_hash).to be_a described_class
          expect(container.instance_variables).to match [:@root_hash]
          expect(container.root_hash.some_array.first).to be_a described_class
          expect(container.root_hash.some_array.first.some_key).to eq "someValue"
          expect(container.root_hash.some_hash).to be_a described_class
          expect(container.root_hash.some_hash.some_key).to eq "someValue"
        end
      end
    end

    context "when passed an array" do
      let(:payload) { [node, node] }

      it "returns an empty object" do
        aggregate_failures do
          expect(container).to be_a described_class
          expect(container.instance_variables).to match []
        end
      end
    end

    context "when passed nil" do
      let(:payload) { nil }

      it "returns an empty object" do
        aggregate_failures do
          expect(container).to be_a described_class
          expect(container.instance_variables).to match []
        end
      end
    end
  end
end
