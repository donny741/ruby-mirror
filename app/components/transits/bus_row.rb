# frozen_string_literal: true

require_relative '../../patches/numeric'

module Components::Transits
  class BusRow
    attr_reader :bus, :x, :y

    HORIZONTAL_PADDING = 1.vw
    VERTICAL_PADDING = 0.3.vh

    def self.for(bus, x:, y:)
      new(bus, x: x, y: y).run
    end

    def initialize(bus, x:, y:)
      @bus = bus
      @x = x + HORIZONTAL_PADDING
      @y = y + VERTICAL_PADDING
    end

    def run
      text_object
      colored_box_objects(text_object.width, text_object.height)
      center_text_object
      [text_object, minutes_left] + @colored_box_objects
    end

    private

    def center_text_object
      return if text_object.text.chars.count != 1

      box_width = @colored_box_objects.first.width + Components::Transits::RectWithRadius::PADDING * 2
      text_x = (box_width / 2) - (@text_object.width / 1.5)
      @text_object.x = x + text_x
    end

    def text_object
      @text_object ||= Text.new(
        bus[:short_name],
        size: 2.5.vh,
        font: 'app/assets/fonts/Fira_Mono/FiraMono-Medium.ttf',
        x: x,
        y: y
      )
    end

    def colored_box_objects(width, height)
      width = height - 1 if height / width >= 2

      @colored_box_objects = Components::Transits::RectWithRadius.for(
        width: width,
        height: height,
        x: x,
        y: y,
        color: bus[:color]
      )
    end

    def preppend_time_to_text
      @text_object.text = "#{@text_object.text} #{minutes_left}"
    end

    def minutes_left
      @minutes_left ||= begin
        time = ((bus[:departure_time] - Time.now) / 60).floor
        time = 0 if time.negative?

        text = "#{time} min"
        minutes_object = Text.new(
          text,
          size: 2.vh,
          x: x,
          y: y
        )
        minutes_object.y += 3
        minutes_object.x = minutes_object.x - minutes_object.width - 1.vw
        minutes_object
      end
    end
  end
end
