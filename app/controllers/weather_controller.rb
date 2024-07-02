class WeatherController < ApplicationController
  def current
    city = params[:city]
    span = OpenTelemetry::Trace.current_span

    # Cache current weather for 10 minutes
    response = Rails.cache.fetch("weather/current/#{city}", expires_in: 10.minutes) do
      span.add_event('Cache miss for current weather')

      # Cache geo coordinate with no expiry
      span.add_event('Fetching geo coordinate')
      coordinate = Rails.cache.fetch("coordinate/#{city}") do
        span.add_event('Cache miss for geo coordinate')
        OpenWeather.geo_coordinate(city)
      end
      span.add_event('Fetched geo coordinate')

      if coordinate
        span.add_event('Fetching current weather')
        current_weather = OpenWeather.current_weather(coordinate)
        span.add_event('Fetched current weather')
        { body: current_weather, status: :ok }
      else
        { body: { error: "City #{city} not found" }, status: :not_found }
      end
    end
    render json: response[:body], status: response[:status]
  end
end
