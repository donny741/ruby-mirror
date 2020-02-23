# frozen_string_literal: true

module Components
  module Calendars
    module Parse
      module_function

      WDAYS_OFFSET = {
        0 => 7,
        1 => 6,
        2 => 5,
        3 => 4,
        4 => 3,
        5 => 9, # showing next week's
        6 => 8  # events from friday
      }.freeze

      def get_upcomming_events_for(calendar_id)
        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = Googles.get_authorizer

        events = service.list_events(calendar_id,
                                     single_events: true,
                                     order_by: 'startTime',
                                     time_min: DateTime.now.rfc3339,
                                     time_max: time_max.rfc3339).items
        events.group_by { |e| e.start.date || e.start.date_time.to_date.to_s }
              .map(&method(:swap_titles))
      end

      def swap_titles(event_group)
        event_group[0] = case event_group[0].to_s
                         when Date.today.to_s
                           'Today'
                         when (Date.today + 1).to_s
                           'Tomorrow'
                         else
                           Date.parse(event_group[0]).strftime('%A, %b %d')
                         end

        event_group
      end

      def time_max
        Date.today + WDAYS_OFFSET[Date.today.wday]
      end
    end
  end
end
