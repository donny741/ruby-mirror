# frozen_string_literal: true

module Components
  class Weather < Components::BaseComponent
    def update
      @weather = weather_info
      temp_object.text = temperature_description

      state_object.remove
      wind_object.remove
      feels_like_object.remove

      state_object.text = state_description
      state_object.x = opts[:x] + temp_object.width + 1.vh
      feels_like_object.text = feels_like_description
      feels_like_object.x = opts[:x] + temp_object.width + 1.2.vh
      wind_object.text = wind_description
      wind_object.x = opts[:x] + temp_object.width + 1.2.vh

      state_object.add
      wind_object.add
      feels_like_object.add
    end

    private

    def temp_object
      @temp_object ||= Text.new('',
                                x: opts[:x],
                                y: opts[:y],
                                size: 12.vh)
    end

    def state_object
      @state_object ||= Text.new('',
                                 y: opts[:y] + 1.8.vh,
                                 size: 4.vh)
    end

    def feels_like_object
      @feels_like_object ||= Text.new('',
                                      y: opts[:y] + 6.9.vh,
                                      size: 2.vh)
    end

    def wind_object
      @wind_object ||= Text.new('',
                                y: opts[:y] + 9.6.vh,
                                size: 2.vh)
    end

    def temperature_description
      temp = @weather['main']['temp'].to_f.round.to_i
      temp_to_string(temp)
    end

    def temp_to_string(temp)
      if temp.positive?
        "+#{temp}"
      else
        temp.to_s
      end
    end

    def state_description
      @weather['weather'][0]['main']
    end

    def feels_like_description
      temp = @weather['main']['feels_like'].to_f.round.to_i
      'Feels like ' + temp_to_string(temp)
    end

    def wind_description
      "Wind #{@weather['wind']['speed'].to_f.round.to_i} m/s"
    end

    def weather_info
      JSON.parse Faraday.get('http://api.openweathermap.org/data/2.5/weather?q=' \
      "#{opts[:city]},#{opts[:country_code]}&APPID=#{opts[:open_weather_api_key]}" \
      '&units=metric').body
    end
  end
end
