require 'rails_helper'
require 'webmock/rspec'

RSpec.describe OpenWeather, type: :service do
  let(:city) { 'Tokyo' }
  let(:api_key) { Rails.configuration.open_weather.api_key }
  let(:lat) { 35.6895 }
  let(:lon) { 139.6917 }

  describe '#geo_coordinate' do
    it 'returns geo coordinates for a city' do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(query: { q: city, appid: api_key, limit: 1 })
        .to_return(
          status: 200,
          body: [{ lat:, lon: }].to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = OpenWeather.geo_coordinate(city)
      expect(result).to eq(lat:, lon:)
    end

    it 'raises an error if the response is unsuccessful' do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(query: { q: city, appid: api_key, limit: 1 })
        .to_return(status: 500)

      expect { OpenWeather.geo_coordinate(city) }.to raise_error(OpenWeather::ApiError)
    end
  end

  describe '#current_weather' do
    let(:coordinate) { { lat:, lon: } }
    let(:temperature) { 25 }
    let(:humidity) { 70 }
    let(:wind_speed) { 5 }
    let(:units) { 'metric' }

    it 'returns current weather for given coordinates' do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
        .with(query: { lat:, lon:, appid: api_key, units: })
        .to_return(
          status: 200,
          body: {
            name: city,
            main: { temp: temperature, humidity: },
            wind: { speed: wind_speed }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = OpenWeather.current_weather(coordinate)
      expect(result).to eq(
        name: city,
        temperature:,
        humidity:,
        wind_speed:
      )
    end

    it 'raises an error if the response is unsuccessful' do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
        .with(query: { lat:, lon:, appid: api_key, units: })
        .to_return(status: 500)

      expect { OpenWeather.current_weather(coordinate) }.to raise_error(OpenWeather::ApiError)
    end
  end
end
