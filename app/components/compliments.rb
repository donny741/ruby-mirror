# frozen_string_literal: true

module Components
  class Compliments
    attr_reader :opts
    attr_accessor :state

    COPMLIMENTS = [
      'Hey, handsome!',
      "You're a gift to those around you!",
      "You're a smart cookie!",
      'You are awesome!',
      'I like your style!',
      'You are the most perfect you there is!',
      'Your perspective is refreshing!'
    ].freeze

    def initialize(opts)
      @counter = 0
      @opts = opts
      @state = 0 # 0 - fading-in, 1 - visible, 2 - fading-out

      update
    end

    def update
      object.remove
      increment_state
      if @state.zero?
        object.text = get_compliment
        object.x = x_centered
      end
      object.add
    end

    def object
      @object ||= Text.new(
        get_compliment,
        {
          font: @default_font,
          size: 3.vw,
          color: 'white',
          opacity: 0
        }.merge!(opts)
      )
    end

    private

    def increment_state
      if @state != 2
        @state += 1
      else
        @state = 0
      end
    end

    def x_centered
      return unless object.width

      opts[:container_width] / 2 - object.width / 2
    end

    def get_compliment
      compliment = COPMLIMENTS[@counter]
      increase_counter

      compliment
    end

    def increase_counter
      @counter += 1
      @counter = 0 if @counter > COPMLIMENTS.count - 1
    end
  end
end
