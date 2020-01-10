# frozen_string_literal: true

module Components
  class CurrentTime
    attr_reader :opts

    def initialize(opts)
      @opts = opts
      object
      seconds

      update
    end

    def update
      object.remove
      seconds.remove

      object.text = hrs_mins
      seconds.text = secs
      seconds.y = opts[:y] + 2.vh

      seconds.add
      object.add
    end

    private

    def object
      @object ||= Text.new(
        hrs_mins,
        {
          font: @default_font,
          size: 10.vh,
          color: 'white'
        }.merge!(opts)
      )
    end

    def seconds
      @seconds ||= Text.new(
        secs,
        font: @default_font,
        size: 5.vh,
        color: 'white',
        y: opts[:y] + 1.vw,
        x: opts[:x] + object.width
      )
    end

    def hrs_mins
      Time.now.strftime('%H:%M')
    end

    def secs
      Time.now.strftime('%S')
    end
  end
end
