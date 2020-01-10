# frozen_string_literal: true

class Resolution
  def initialize(width: 1080, height: 1920, scale: 1.0)
    @width = width
    @height = height
    @scale = scale
  end

  def width
    @width * @scale
  end

  def height
    @height * @scale
  end
end
