# frozen_string_literal: true

module Components
  class CurrentTime
    attr_reader :opts, :object

    def initialize(opts)
      @opts = opts
      @object = create_text
    end

    def update
      @object.remove
      @object = create_text
      @object.add
    end

    private

    def create_text
      Text.new(
        formatted_time,
        {
          font: @default_font,
          size: 10.vh,
          color: 'white'
        }.merge!(opts)
      )
    end

    def formatted_time
      Time.now.strftime('%H:%M:%S')
    end
  end
end
