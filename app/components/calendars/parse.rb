# frozen_string_literal: true

require 'icalendar'
require 'faraday'

module Components
  module Calendars
    module Parse
      module_function

      DATES = [Date.today, Date.tomorrow, Date.today + 2, Date.today + 3].freeze

      def get_upcomming_events
        response = Faraday.get ICAL_URL
        cals = Icalendar::Calendar.parse(response.body)
        cal = cals.first

        events = cal.events.select { |e| DATES.include? e.dtstart.to_date }
        events.group_by(&:dtstart).map(&method(:swap_titles))
      end

      def swap_titles(event_group)
        case event_group[0].to_date
        when Date.today
          event_group[0] = 'Today'
        when Date.tomorrow
          event_group[0] = 'Tomorrow'
        else
          event_group[0] = event_group[0].to_date.strftime
        end

        event_group
      end
    end
  end
end
