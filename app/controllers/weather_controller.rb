class WeatherController < ApplicationController
  def current
    city = params[:city]
    open_weather = OpenWeather.new
    coordinate = open_weather.geo_coordinate(city)
    if coordinate
      current_weather = open_weather.current_weather(coordinate)
      render json: current_weather
    else
      render json: { error: "City #{city} not found" }, status: :not_found
    end
  end
end
