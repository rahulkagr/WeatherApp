class WeatherService

  attr_reader :address, :pin_code

  HOST = 'https://api.openweathermap.org'
  ENDPOINT = '/data/2.5/weather'
  CACHE_EXPIRY_TIME = 30.minutes

  def initialize(params)
    params = params.with_indifferent_access
    @address = params[:address]
    @pin_code = params[:pincode]
  end

  def execute
    location_info = fetch_location_info
    weather_details = fetch_weather(location_info)
  end

  private

  def fetch_weather(location_info)
    key = pin_code
    cache_exist = Rails.cache.exist?(key)
    response = Rails.cache.fetch(key, expires_in: CACHE_EXPIRY_TIME) do
     get_weather(location_info)
    end
    response.merge!(cached: cache_exist)
  end

  def fetch_location_info
    resp = GeocoderService.new(pin_code: pin_code).execute
    raise "Invalid response from Geocoder Service" if resp.latitude.blank? || resp.longitude.blank?
    resp
  end

  def get_weather(location_info)
    params = prepare_params(location_info)
    call_open_weather_api(params)
  end

  def prepare_params(location_info)
    {
      lat: location_info.latitude,
      lon: location_info.longitude,
      appid: ENV['OPEN_WEATHER_API_KEY'],
      units: 'metric'
    }
  end

  def call_open_weather_api(params)
    response = Interfaces::ExternalApi.call(HOST, ENDPOINT, 'get', {}, params)
    raise "Invalid response from OpenWeather API" if invalid_open_weather_response?(response)
    parse_weather_response(response)
  end

  def invalid_open_weather_response?(response)
    response.blank? || response[:body].blank?
  end

  def parse_weather_response(response)
    body = response.with_indifferent_access[:body]
    {
      temperature: body[:main][:temp],
      temp_min: body[:main][:temp_min],
      temp_max: body[:main][:temp_max],
      pressure: body[:main][:pressure],
      humidity: body[:main][:humidity],
      wind_speed: body[:wind][:speed],
      weather_description: body[:weather].first[:description]
    }
  end
end
