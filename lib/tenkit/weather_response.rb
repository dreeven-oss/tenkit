require_relative "response"

module Tenkit
  class WeatherResponse < Response
    attr_reader :weather

    def initialize(response)
      super

      unless response.success?
        raise RequestError.new("Unsuccessful Weather API request (#{response.code})", response: response)
      end

      @weather = Weather.new(response)
    end
  end
end
