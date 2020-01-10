# frozen_string_literal: true

require 'ruby2d'
require 'pry'

Dir[Dir.pwd + '/**/*.rb'].each { |f| require f }

@default_font = 'app/assets/fonts/maison.otf'
SCALE = 0.4
MAX_TICK = 360

resolution = Resolution.new(scale: SCALE)
grid = Grid.new(x: resolution.width,
                y: resolution.height,
                rows: 12,
                cols: 12)

set title: 'Ruby Mirror',
    background: 'black',
    fullscreen: false,
    height: resolution.height,
    width: resolution.width,
    resizeable: false,
    diagnostics: true

time = Components::CurrentTime.new(grid.start_coordinates(x: 2, y: 2))

tick = 0
update do
  if tick % 20 == 0
    time.update
  end

  tick = 0 if tick == MAX_TICK
  tick += 1
end

on :key do |e|
  close if e.key == 'escape'
end

show
