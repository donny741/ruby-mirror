# frozen_string_literal: true

module Components
  class Calendar < Components::BaseComponent
    def update
      event_cells.each(&:remove)
      event_titles.each(&:remove)

      @event_cells = nil
      @event_titles = nil

      event_cells.each(&:add)
    end

    private

    def event_cells
      row = 1
      @event_cells ||= event_groups.map do |date, events|
        row += 1 unless event_groups[0][0] == date
        event_titles << Text.new(
          date,
          font: DEFAULT_FONT,
          size: 4.vh,
          color: 'white',
          x: opts[:x],
          y: opts[:y] + 8.vh + 4.vh * row
        )
        e = events&.map do |event|
          row += 1.2
          Text.new(
            event.summary.force_encoding('utf-8').encode('iso-8859-4'),
            font: DEFAULT_FONT,
            size: 3.vh,
            color: 'white',
            x: opts[:x],
            y: opts[:y] + 9.vh + 4.vh * row
          )
        end
        row += 1
        e
      end.flatten.compact
    end

    def event_titles
      @event_titles ||= []
    end

    def event_groups
      Components::Calendars::Parse.get_upcomming_events
    end
  end
end
