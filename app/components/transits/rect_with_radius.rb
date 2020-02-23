# frozen_string_literal: true

module Components::Transits
  class RectWithRadius
    attr_reader :opts

    PADDING = 1.vw

    def self.for(opts)
      new(opts).run
    end

    def initialize(opts)
      @opts = opts
    end

    def run
      [
        main_rect,
        left_padding,
        right_padding,
        top_padding,
        bottom_padding,
        top_left_circle,
        top_right_circle,
        bottom_left_circle,
        bottom_right_circle
      ]
    end

    def main_rect
      Rectangle.new(
        x: opts[:x],
        y: opts[:y],
        z: opts[:z] || -1,
        width: opts[:width],
        height: opts[:height],
        color: opts[:color],
      )
    end

    def left_padding
      Rectangle.new(
        x: opts[:x] - PADDING,
        y: opts[:y],
        z: opts[:z] || -1,
        width: PADDING,
        height: opts[:height],
        color: opts[:color]
      )
    end

    def right_padding
      Rectangle.new(
        x: opts[:x] + opts[:width],
        y: opts[:y],
        z: opts[:z] || -1,
        width: PADDING,
        height: opts[:height],
        color: opts[:color]
      )
    end

    def top_padding
      Rectangle.new(
        x: opts[:x],
        y: opts[:y] - PADDING,
        z: opts[:z] || -1,
        width: opts[:width],
        height: PADDING,
        color: opts[:color]
      )
    end

    def bottom_padding
      Rectangle.new(
        x: opts[:x],
        y: opts[:y] + opts[:height],
        z: opts[:z] || -1,
        width: opts[:width],
        height: PADDING,
        color: opts[:color]
      )
    end

    def top_left_circle
      Circle.new(
        x: opts[:x],
        y: opts[:y],
        radius: PADDING,
        color: opts[:color]
      )
    end

    def top_right_circle
      Circle.new(
        x: opts[:x] + opts[:width],
        y: opts[:y],
        radius: PADDING,
        color: opts[:color]
      )
    end

    def bottom_left_circle
      Circle.new(
        x: opts[:x],
        y: opts[:y] + opts[:height],
        radius: PADDING,
        color: opts[:color]
      )
    end

    def bottom_right_circle
      Circle.new(
        x: opts[:x] + opts[:width],
        y: opts[:y] + opts[:height],
        radius: PADDING,
        color: opts[:color]
      )
    end
  end
end
