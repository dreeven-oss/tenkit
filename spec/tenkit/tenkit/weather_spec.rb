require_relative "../spec_helper"

RSpec.describe Tenkit::Weather do
  let(:lat) { 37.32 }
  let(:lon) { 122.03 }
  let(:path) { "/weather/en/#{lat}/#{lon}" }
  let(:data_sets) { [Tenkit::Utils.snake(data_set).to_sym] }
  let(:query) { {query: {dataSets: data_set}} }

  let(:client) { Tenkit::Client.new }
  let(:json) { File.read("test/fixtures/#{data_set}.json") }

  before do
    stub_request(:any, /#{Tenkit::Client.base_uri}/).to_return(
      body: json, headers: {content_type: "application/json"}
    )
    allow(client).to receive(:get).and_call_original
  end

  describe "currentWeather" do
    subject(:result) { client.weather(lat, lon, data_sets: data_sets).weather.current_weather }

    let(:data_set) { "currentWeather" }

    it "returns response from correct data_sets" do
      result
      expect(client).to have_received(:get).with(path, query)
    end

    it "includes expected metadata" do
      aggregate_failures do
        expect(result.name).to eq "CurrentWeather"
        expect(result.metadata.attribution_url).to start_with "https://"
        expect(result.metadata.latitude).to be 37.32
        expect(result.metadata.longitude).to be 122.03
      end
    end

    it "returns correct object types" do
      aggregate_failures do
        expect(result).to be_a Tenkit::CurrentWeather
        expect(result.metadata).to be_a Tenkit::Metadata
      end
    end

    it "returns current weather data" do
      aggregate_failures do
        expect(result.temperature).to be(-5.68)
        expect(result.temperature_apparent).to be(-6.88)
      end
    end

    context "without options" do
      subject(:result) { client.weather(lat, lon).weather.current_weather }

      it "returns response from default currentWeather data set" do
        aggregate_failures do
          expect(result.name).to eq "CurrentWeather"
          expect(client).to have_received(:get).with(path, query)
        end
      end
    end
  end

  describe "forecastDaily" do
    subject(:result) { client.weather(lat, lon, data_sets: data_sets).weather.forecast_daily }

    let(:data_set) { "forecastDaily" }
    let(:first_day) { subject.days.first }

    it "returns 10 days of data from correct data sets" do
      aggregate_failures do
        expect(result.days.size).to be 10
        expect(client).to have_received(:get).with(path, query)
      end
    end

    it "returns correct object types" do
      aggregate_failures do
        expect(result).to be_a Tenkit::DailyForecast
        expect(first_day).to be_a Tenkit::DayWeatherConditions
        expect(first_day.daytime_forecast).to be_a Tenkit::DaytimeForecast
        expect(first_day.overnight_forecast).to be_a Tenkit::OvernightForecast
        expect(first_day.rest_of_day_forecast).to be_a Tenkit::RestOfDayForecast
      end
    end

    it "excludes learn_more_url node" do
      expect(result.respond_to?(:learn_more_url)).to be false
    end

    it "includes expected metadata" do
      aggregate_failures do
        expect(result.name).to eq "DailyForecast"
        expect(result.metadata.attribution_url).to start_with "https://"
        expect(result.metadata.latitude).to be 37.32
        expect(result.metadata.longitude).to be 122.03
      end
    end

    it "returns daily forecast data" do
      aggregate_failures do
        expect(first_day.condition_code).to eq "Clear"
        expect(first_day.max_uv_index).to be 2
        expect(first_day.temperature_max).to be 6.34
        expect(first_day.temperature_min).to be(-6.35)
      end
    end

    it "returns daytime and overnight forecast data" do
      aggregate_failures do
        expect(first_day.daytime_forecast.condition_code).to eq "Clear"
        expect(first_day.daytime_forecast.temperature_max).to be 6.34
        expect(first_day.overnight_forecast.condition_code).to eq "Clear"
        expect(first_day.overnight_forecast.temperature_max).to be(-0.28)
      end
    end
  end

  describe "forecastHourly" do
    subject(:result) { client.weather(lat, lon, data_sets: data_sets).weather.forecast_hourly }

    let(:data_set) { "forecastHourly" }
    let(:first_hour) { subject.hours.first }

    it "returns 25 hours of data from correct data sets" do
      aggregate_failures do
        expect(result.hours.size).to be 25
        expect(client).to have_received(:get).with(path, query)
      end
    end

    it "includes expected metadata" do
      aggregate_failures do
        expect(result.name).to eq "HourlyForecast"
        expect(result.metadata.attribution_url).to start_with "https://"
        expect(result.metadata.latitude).to be 37.32
        expect(result.metadata.longitude).to be 122.03
      end
    end

    it "returns correct object types" do
      aggregate_failures do
        expect(result).to be_a Tenkit::HourlyForecast
        expect(first_hour).to be_a Tenkit::HourWeatherConditions
      end
    end

    it "returns hourly forecast data" do
      aggregate_failures do
        expect(first_hour.condition_code).to eq "MostlyClear"
        expect(first_hour.temperature).to be(-5.86)
      end
    end
  end
end
