# frozen_string_literal: true

module Components::Transits
  class Request
    attr_reader :opts

    def self.for(opts)
      new(opts).find_buses
    end

    def initialize(opts)
      @opts = opts
    end

    def find_buses
      opts[:destinations].map do |destination|
        response = request(destination)
        routes = response.dig(:routes)
        p "Found #{routes.size} routes for #{destination}"
        { buses: routes.map(&method(:find_first_bus)), destination: destination }
      end
    end

    def find_first_bus(route)
      bus_step = route.dig(:legs, 0, :steps)
                      .select { |step| step[:travel_mode] == 'TRANSIT' }
                      .first
      bus_details = bus_step.dig(:transit_details, :line)
                            .slice(:short_name, :color, :vehicle, :text_color)
      departure = bus_step.dig(:transit_details, :departure_time, :value)

      bus_details.merge!(departure_time: Time.at(departure))
    end

    def request(destination)
      response = Faraday.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        key: opts[:key],
        origin: opts[:origin],
        destination: destination,
        mode: 'transit',
        transit_mode: 'bus'
      )
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
