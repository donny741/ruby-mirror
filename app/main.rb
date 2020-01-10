# frozen_string_literal: true

require 'ruby2d'
require 'pry'
require 'dotenv/load'

Dir[Dir.pwd + '/**/*.rb'].each { |f| require f }

resolution = Resolution.new(scale: SCALE)
grid = Grid.new(x: resolution.width,
                y: resolution.height,
                rows: 12,
                cols: 12)

set title: 'Ruby Mirror',
    background: '#000000',
    fullscreen: false,
    height: resolution.height,
    width: resolution.width,
    resizeable: false,
    diagnostics: true

time = Components::CurrentTime.new(grid.start_cell(x: 2, y: 2))
compliments = Components::Compliments.new(grid.start_cell(x: 3, y: 11)
                                          .merge(container_width: grid.x))
tick = 0
update do
  time.update if tick % 10 == 0
  compliments.update if tick % 360 == 0

  if compliments.state == 0
    compliments.object.opacity += 0.01 if compliments.object.opacity <= 1.0
  end
  if compliments.state == 2
    compliments.object.opacity -= 0.01 if compliments.object.opacity >= 0.0
  end

  tick = 0 if tick == MAX_TICK
  tick += 1
end

on :key do |e|
  close if e.key == 'escape'
end

show
