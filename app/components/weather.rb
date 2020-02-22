# frozen_string_literal: true

module Components
  class Weather < Components::BaseComponent
    TEXT_OBJECTS = %i[state feels_like wind].freeze

    def update
      @weather = weather_info
      temp_object.text = temperature_description

      TEXT_OBJECTS.each(&method(:remove_text_object))
      state_object.x = right_from_temp_obj_aligned_left(1.vh)
      feels_like_object.x = right_from_temp_obj_aligned_left(1.2.vh)
      wind_object.x = right_from_temp_obj_aligned_left(1.2.vh)
      TEXT_OBJECTS.each(&method(:change_description))
      TEXT_OBJECTS.each(&method(:add_text_object))
    end

    private

    def remove_text_object(object_name)
      send("#{object_name}_object", &:remove)
    end

    def change_description(object_name)
      send("#{object_name}_object").text = send("#{object_name}_description")
    end

    def add_text_object(object_name)
      send("#{object_name}_object", &:add)
    end

    def right_from_temp_obj_aligned_left(offset)
      opts[:x] + temp_object.width + offset
    end

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
