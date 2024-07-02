class WeatherController < ApplicationController
  def current
    city = params[:city]
    span = OpenTelemetry::Trace.current_span
    open_weather = OpenWeather.new

    span.add_event('Fetching current weather')
    # Cache current weather for 10 minutes
    Rails.cache.fetch("weather/current/#{city}", expires_in: 10.minutes) do
      span.add_event('Cache miss for current weather')

      # Cache geo coordinate with no expiry
      span.add_event('Fetching geo coordinate')
      coordinate = Rails.cache.fetch("coordinate/#{city}") do
        span.add_event('Cache miss for geo coordinate')
        open_weather.geo_coordinate(city)
      end
      span.add_event('Fetched geo coordinate')

      if coordinate
        current_weather = open_weather.current_weather(coordinate)
        span.add_event('Fetched current weather')
        render json: current_weather
      else
        render json: { error: "City #{city} not found" }, status: :not_found
      end
    end
  end
end
