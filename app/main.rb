# frozen_string_literal: true

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
    disabled: false,
    options: {
      update_interval: 11_520,
      play_with_fire: true,
      y_offset: 2.vh
    }.merge!(GRID.start_cell(x: 2, y: 3))
  },
  {
    class: 'List',
    disabled: true,
    options: {
      row_count: 1,
      rows: [
        {
          text: 'New row',
          size: 2.vh,
          color: 'white',
          x: 2.vh,
          y: 2.vh
        }
      ]
    }
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

  tick += 1
end

on :key do |e|
  close if e.key == 'escape'
end

show
