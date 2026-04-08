require_relative "utils"

module Tenkit
  class Container
    def initialize(contents)
      return unless contents.is_a?(Hash)

      contents.each do |key, value|
        name = Tenkit::Utils.snake(key)
        singleton_class.class_eval { attr_accessor name }
        mapped_value = if value.is_a?(Array)
          case key
          when "days"
            value.map { |e| DayWeatherConditions.new(e) }
          when "hours"
            value.map { |e| HourWeatherConditions.new(e) }
          when "features"
            value.map { |e| Feature.new(e) }
          when "messages"
            value.map { |e| Message.new(e) }
          when "coordinates"
            Coordinates.new(value)
          else
            value.map { |e| Container.new(e) }
          end
        elsif value.is_a?(Hash)
          case key
          when "metadata"
            Metadata.new(value)
          when "daytimeForecast"
            DaytimeForecast.new(value)
          when "overnightForecast"
            OvernightForecast.new(value)
          when "restOfDayForecast"
            RestOfDayForecast.new(value)
          when "area"
            Area.new(value)
          when "geometry"
            Geometry.new(value)
          else
            Container.new(value)
          end
        else
          value
        end

        instance_variable_set(:"@#{name}", mapped_value)
      end
    end
  end

  class CurrentWeather < Container; end

  class HourlyForecast < Container; end

  class DailyForecast < Container; end

  class WeatherAlertSummary < Container; end

  class HourWeatherConditions < Container; end

  class Feature < Container; end

  class Message < Container; end

  class Coordinates < Array; end

  class DayWeatherConditions < Container; end

  class Metadata < Container; end

  class DaytimeForecast < Container; end

  class OvernightForecast < Container; end

  class RestOfDayForecast < Container; end

  class Area < Container; end

  class Geometry < Container; end
end
