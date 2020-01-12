# frozen_string_literal: true

module Components
  class Calendar < Components::BaseComponent
    def update
      event_cells.each(&:remove)
      event_cells.each(&:add)
    end

    private

    def title
      @title ||= Text.new(
        'Upcomming events',
        {
          font: DEFAULT_FONT,
          size: 5.vh,
          color: 'white'
        }.merge!(opts)
      )
    end

    def event_cells
      row = 1
      @event_cells ||= event_groups.map do |date, events|
        row += 1 unless event_groups[0][0] == date
        Text.new(
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

    def event_groups
      @event_groups ||= Components::Calendars::Parse.get_upcomming_events
    end
  end
end
