# frozen_string_literal: true

module Components
  class Weather < Components::BaseComponent
    def update
      @weather = weather_info
      temp_object.text = temperature
      state_object.text = state_description
    end

    private

    def temp_object
      @temp_text ||= Text.new('',
        x: opts[:x],
        y: opts[:y],
        size: 16.vh
      )
    end

    def state_object
      @state_object ||= Text.new('',
        x: opts[:x] + temp_object.width,
        y: opts[:y] + 3.vh,
        size: 4.vh
      )
    end

    def temperature
      temp = @weather['main']['temp'].to_f.round.to_i
      if temp.positive?
        "+#{temp}"
      elsif temp.zero?
        temp.to_s
      else
        "-#{temp}"
      end
    end

    def state_description
      @weather['weather'][0]['main']
    end

    def weather_info
      JSON.parse Faraday.get('http://api.openweathermap.org/data/2.5/weather?q=' \
      "#{opts[:city]},#{opts[:country_code]}&APPID=#{opts[:open_weather_api_key]}" \
      '&units=metric').body
    end
  end
end
