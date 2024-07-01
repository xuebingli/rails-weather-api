class WeatherController < ApplicationController
  def current
    city = params[:city]
    span = OpenTelemetry::Trace.current_span
    open_weather = OpenWeather.new
    span.add_event('Fetching geo coordinate')
    coordinate = open_weather.geo_coordinate(city)
    span.add_event('Fetched geo coordinate')
    if coordinate
      span.add_event('Fetching current weather')
      current_weather = open_weather.current_weather(coordinate)
      span.add_event('Fetched current weather')
      render json: current_weather
    else
      render json: { error: "City #{city} not found" }, status: :not_found
    end
  end
end
