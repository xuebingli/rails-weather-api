module OpenWeather
  include HTTParty

  config = Rails.configuration.open_weather
  API_KEY = config[:api_key].freeze
  TIMEOUT_SECONDS = config[:timeout_seconds].freeze

  base_uri 'api.openweathermap.org'
  default_timeout TIMEOUT_SECONDS

  class ApiError < StandardError; end

  def self.geo_coordinate(city)
    response = get('/geo/1.0/direct',
                   query: { q: city, appid: API_KEY, limit: 1 })
    raise ApiError.new(response) unless response.success?

    data = response.first
    return unless data

    { lat: data['lat'], lon: data['lon'] }
  end

  def self.current_weather(coordinate)
    response = get('/data/2.5/weather',
                   query: { lat: coordinate[:lat], lon: coordinate[:lon], appid: API_KEY, units: 'metric' })
    raise ApiError.new(response) unless response.success?

    data = response.parsed_response
    {
      name: data['name'],
      temperature: data['main']['temp'],
      humidity: data['main']['humidity'],
      wind_speed: data['wind']['speed']
    }
  end
end
