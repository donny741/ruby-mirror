# frozen_string_literal: true

module Components
  class Calendar < Components::BaseComponent
    def update
      clear_list
      update_list
    end

    private

    def clear_list
      # this is very sketchy...
      list_items.each(&:remove_and_free_text)
    end

    def list_items
      @list_items ||= []
    end

    def update_list
      y_offset = 0
      event_groups.flatten.each do |event|
        case event
        when String
          list_items << Text.new(event,
                                 size: 4.vh,
                                 color: 'white',
                                 x: opts[:x],
                                 y: opts[:y] + y_offset + 1.vh)
          y_offset += 8.vh
        when Google::Apis::CalendarV3::Event
          list_items << Text.new(event.summary,
                                 size: 3.vh,
                                 color: 'white',
                                 x: opts[:x],
                                 y: opts[:y] + y_offset)
          y_offset += 6.vh
        end
      end
    end

    def event_groups
      Components::Calendars::Parse.get_upcomming_events
    end
  end
end
