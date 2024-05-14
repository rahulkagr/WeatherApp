module V1
  class WeatherController < ApplicationController

    before_action :set_weather_params, only: [:show]

    # GET v1/weather
    def show
      if weather_params[:address].present? && weather_params[:pincode].present?
        @address = weather_params[:address]
        @pincode = weather_params[:pincode]
        @weather = WeatherService.new(weather_params.to_hash).execute
      end
    end

    private

    def set_weather_params
      @weather_params = params.permit(:address, :pincode)
    end

    def weather_params
      @weather_params
    end
  end
end
