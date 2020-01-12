# frozen_string_literal: true

module Components
  module Calendars
    module Parse
      module_function

      DATES = [Date.today, Date.today + 1, Date.today + 2, Date.today + 3].freeze

      def get_upcomming_events
        response = Faraday.get ICAL_URL
        cals = Icalendar::Calendar.parse(response.body)
        cal = cals.first

        events = cal.events.select { |e| DATES.map(&:to_s).include? e.dtstart.to_date.to_s }
        events.group_by { |e| e.dtstart.to_date }.map(&method(:swap_titles))
      end

      def swap_titles(event_group)
        case event_group[0].to_date
        when Date.today
          event_group[0] = 'Today'
        when Date.today + 1
          event_group[0] = 'Tomorrow'
        else
          event_group[0] = event_group[0].to_date.strftime
        end

        event_group
      end
    end
  end
end
