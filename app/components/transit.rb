# frozen_string_literal: true

module Components
  class Transit < Components::BaseComponent
    attr_accessor :routes

    def initialize(opts)
      super

      @routes = find_buses
      draw_table
      @thread = {}
    end

    def update
      handle_completed_thread
      draw_table
      request_update if update_needed?
    end

    private

    def draw_table
      clear_list
      draw_list
    end

    def clear_list
      list_items.each(&method(:remove))
    end

    def remove(item)
      # you can't remove items from @list_items because the fire will spread
      item.send opts[:play_with_fire] ? :remove_and_free_text : :remove
    end

    def draw_list
      y_offset = opts[:y_offset] || 0
      @routes.each do |route|
        list_items << Text.new(
          route[:destination],
          size: 2.5.vh,
          color: 'white',
          x: opts[:x],
          y: opts[:y] + y_offset + 1.vh
        )
        y_offset += 4.vh
        add_bus_objects(route, y_offset)
        y_offset += 2.vh
      end
    end

    def add_bus_objects(route, y_offset)
      route[:buses].each do |bus|
        list_items << Text.new(
          "#{bus[:short_name]} in #{format_time(bus[:departure_time])} min.",
          size: 1.5.vh,
          x: opts[:x],
          y: opts[:y] + y_offset
        )
        y_offset += 3.5.vh
      end
    end

    def format_time(time)
      time = ((time - Time.now) / 60).floor
      return 0 if time.negative?

      time
    end

    def list_items
      @list_items ||= []
    end

    def handle_completed_thread
      return if @thread[:output].nil?

      @routes = @thread[:output]
      @thread = {}
    end

    def request_update
      @thread = Thread.new { Thread.current[:output] = find_buses }
      p "Update requested. Thread: #{@thread}"
    end

    def find_buses
      Transits::Request.for(opts)
    end

    def update_needed?
      routes.any? do |route|
        route[:buses].any?(&method(:not_departed?))
      end
    end

    def not_departed?(bus)
      bus[:departure_time] < Time.now
    end
  end
end
