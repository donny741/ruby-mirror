# frozen_string_literal: true

class Grid
  attr_reader :x, :y, :rows, :cols, :cell_height,
              :cell_width, :x_offset, :y_offset

  def initialize(x:, y:, rows:, cols:, x_offset: 0, y_offset: 0)
    @x = x
    @y = y
    @rows = rows
    @cols = cols
    @cell_width = x / cols
    @cell_height = y / rows
    @x_offset = x_offset
    @y_offset = y_offset
  end

  def start_coordinates(x:, y:)
    {
      x: x_offset + cell_width * (x - 1),
      y: y_offset + cell_height * (y - 1)
    }
  end

  def dimensions(x_len, y_len)
    {
      width: x_len * cell_width,
      height: y_len * cell_height
    }
  end
end
