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
      colored_box_object(text_object.width, text_object.width)
      append_time_to_text

      [text_object, @colored_box_object]
    end

    private

    def text_object
      @text_object ||= Text.new(
        bus[:short_name],
        size: 1.5.vh,
        x: x,
        y: y
      )
    end

    def colored_box_object(width, height)
      @colored_box_object ||= Rectangle.new(
        x: x - HORIZONTAL_PADDING,
        y: y - VERTICAL_PADDING,
        z: -1,
        width: width + 2 * HORIZONTAL_PADDING,
        height: height + 2 * VERTICAL_PADDING,
        color: bus[:color]
      )
    end

    def append_time_to_text
      @text_object.text = "#{@text_object.text} #{minutes_left}"
    end

    def minutes_left
      time = ((bus[:departure_time] - Time.now) / 60).floor
      time = 0 if time.negative?

      "  in #{time} min."
    end
  end
end
