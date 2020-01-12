# frozen_string_literal: true

module Components
  module Calendars
    module Parse
      module_function

      CALENDAR_ID = 'donatas.povilaitis@vinted.com'
      # CALENDAR_ID = 'friendlyfashion.co.uk_9f8sco84m2tkl1rfr715go6hug@group.calendar.google.com'

      def get_upcomming_events
        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = Googles.get_authorizer

        events = service.list_events(CALENDAR_ID,
                                     single_events: true,
                                     order_by: 'startTime',
                                     time_min: DateTime.now.rfc3339,
                                     time_max: time_max.rfc3339).items
        events.group_by { |e| e.start.date || e.start.date_time.to_date.to_s }
              .map(&method(:swap_titles))
      end

      def swap_titles(event_group)
        event_group[0] = case event_group[0]
                         when Date.today
                           'Today'
                         when Date.today + 1
                           'Tomorrow'
                         else
                           event_group[0]
                         end

        event_group
      end

      def time_max
        if Date.today.saturday? || Date.today.sunday?
          Date.today.next_week.end_of_week
        else
          Date.today.end_of_week
        end
      end
    end
  end
end
