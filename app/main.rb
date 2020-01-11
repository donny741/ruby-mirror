# frozen_string_literal: true

require 'ruby2d'
require 'pry'
require 'dotenv/load'

require_relative './components/base_component'
Dir[Dir.pwd + '/**/*.rb'].each { |f| require f }

RESOLUTION = Resolution.new(scale: SCALE)
GRID = Grid.new(x: RESOLUTION.width,
                y: RESOLUTION.height,
                rows: 12,
                cols: 12)

COMPONENTS = [
  {
    class: 'CurrentTime',
    disabled: false,
    options: {
      update_interval: 10,
      font: DEFAULT_FONT
    }.merge!(GRID.start_cell(x: 2, y: 2))
  },
  {
    class: 'Compliments',
    disabled: false,
    options: {
      update_interval: 360,
      container_width: GRID.x
    }.merge!(GRID.start_cell(x: 3, y: 11))
  },
  {
    class: 'Calendar',
    disabled: true,
    options: {
      pdate_interval: 1440,
    }.merge!(GRID.start_cell(x: 2, y: 3))
  }
].freeze

set title: 'Ruby Mirror',
    background: '#000000',
    fullscreen: false,
    height: RESOLUTION.height,
    width: RESOLUTION.width,
    resizeable: false,
    diagnostics: true

components = Components.load

# TODO: find another way to hook into compliments controller
compliments = components.select { |c| c.is_a? Components::Compliments }.first

tick = 0
update do
  components.each do |component|
    component.update if tick % component.update_interval == 0
  end

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
