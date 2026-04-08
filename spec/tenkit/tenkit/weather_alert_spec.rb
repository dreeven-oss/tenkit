require_relative "../spec_helper"

RSpec.describe Tenkit::WeatherAlert do
  let(:client) { Tenkit::Client.new }
  let(:json) { File.read("test/fixtures/alert.json") }

  before do
    stub_request(:any, /#{Tenkit::Client.base_uri}/).to_return(
      body: json, headers: {content_type: "application/json"}
    )
  end

  describe "weather_alert" do
    subject(:result) { client.weather_alert(alert_id).weather_alert.summary }

    let(:alert_id) { "0828b382-f63c-4139-9f4f-91a05a4c7cdd" }

    it "includes expected message" do
      aggregate_failures do
        expect(result.messages.first).to be_a Tenkit::Message
        expect(result.messages.first.language).to eq "en"
        expect(result.messages.first.text).to start_with "...HEAT ADVISORY"
        expect(result.messages.first.text).to end_with "outdoor activities."
      end
    end

    it "includes expected area feature" do
      aggregate_failures do
        expect(result.area).to be_a Tenkit::Area
        expect(result.area.type).to eq "FeatureCollection"
        expect(result.area.features.first).to be_a Tenkit::Feature
        expect(result.area.features.first.type).to eq "Feature"
        expect(result.area.features.first.geometry).to be_a Tenkit::Geometry
        expect(result.area.features.first.geometry.type).to eq "Polygon"
        expect(result.area.features.first.geometry.coordinates).to be_a Tenkit::Coordinates
        expect(result.area.features.first.geometry.coordinates.size).to be 1
        expect(result.area.features.first.geometry.coordinates.first.size).to be 177
        expect(result.area.features.first.geometry.coordinates.first.first).to match [-122.4156, 38.8967]
      end
    end

    it "includes expected summary data" do # rubocop:disable RSpec/MultipleExpectations
      aggregate_failures do
        expect(result.area_id).to eq "caz017"
        expect(result.area_name).to eq "Southern Sacramento Valley"
        expect(result.certainty).to eq "likely"
        expect(result.country_code).to eq "US"
        expect(result.description).to eq "Heat Advisory"
        expect(result.details_url).to start_with "https://"
        expect(result.effective_time).to eq "2022-08-20T08:54:00Z"
        expect(result.event_end_time).to eq "2022-08-21T02:00:00Z"
        expect(result.event_source).to eq "US"
        expect(result.expire_time).to eq "2022-08-21T02:00:00Z"
        expect(result.id).to eq "cbff5515-5ed0-518b-ae8b-bcfdd5844d41"
        expect(result.importance).to eq "low"
        expect(result.issued_time).to eq "2022-08-20T08:54:00Z"
        expect(result.name).to eq "WeatherAlert"
        expect(result.precedence).to be 0
        expect(result.responses).to be_empty
        expect(result.severity).to eq "minor"
        expect(result.source).to eq "National Weather Service"
        expect(result.urgency).to eq "expected"
      end
    end
  end
end
