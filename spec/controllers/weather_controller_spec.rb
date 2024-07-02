require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #current' do
    context 'when the city is found' do
      let(:city) { 'Tokyo' }
      let(:coordinate) { { lat: 35.6895, lon: 139.6917 } }
      let(:current_weather) { { temperature: 293.25, humidity: 78, wind_speed: 4.1 } }

      before do
        open_weather = instance_double('OpenWeather')
        allow(OpenWeather).to receive(:new).and_return(open_weather)
        allow(open_weather).to receive(:geo_coordinate).with(city).and_return(coordinate)
        allow(open_weather).to receive(:current_weather).with(coordinate).and_return(current_weather)
      end

      it 'returns the current weather data' do
        get :current, params: { city: }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(current_weather.stringify_keys)
      end
    end

    context 'when the city is not found' do
      let(:city) { 'Non-existing-city' }

      before do
        open_weather = instance_double('OpenWeather')
        allow(OpenWeather).to receive(:new).and_return(open_weather)
        allow(open_weather).to receive(:geo_coordinate).with(city).and_return(nil)
      end

      it 'returns a not found error' do
        get :current, params: { city: }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => "City #{city} not found" })
      end
    end
  end
end
