class OpenWeather
  include HTTParty
  base_uri 'api.openweathermap.org'

  def initialize
    @api_key = ENV['OPENWEATHER_API_KEY'] 
  end

  def geo_coordinate(city)
    response = self.class.get("/geo/1.0/direct", 
      query: { q: city, appid: @api_key, limit: 1 }
    )
    return unless response.success?
    data = response.parsed_response
    return if data.size < 1
    {
      lat: data[0]['lat'],
      lon: data[0]['lon'],
    }
  end

  def current_weather(coordinate)
    response = self.class.get("/data/2.5/weather", 
      query: { lat:coordinate[:lat], lon: coordinate[:lon], appid: @api_key, units: 'metric' }
    )
    return unless response.success?
    data = response.parsed_response
    {
      name: data['name'],
      temperature: data['main']['temp'],
      humidity: data['main']['humidity'],
      wind_speed: data['wind']['speed'],
    }
  end
end
