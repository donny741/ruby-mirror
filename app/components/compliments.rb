# frozen_string_literal: true

module Components
  class Compliments
    attr_reader :opts, :object, :counter

    COPMLIMENTS = [
      'Hey, handsome',
      "You're a gift to those around you",
      "You're a smart cookie",
      'You are awesome!',
      'I like your style',
      'You are the most perfect you there is',
      'Your perspective is refreshing'
    ].freeze

    def initialize(opts)
      @counter = 0
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
        get_compliment,
        {
          font: @default_font,
          size: 3.vw,
          color: 'white'
        }.merge!(opts)
      )
    end

    def get_compliment
      compliment = COPMLIMENTS[@counter]
      increase_counter

      compliment
    end

    def increase_counter
      @counter += 1
      @counter = 0 if counter > COPMLIMENTS.count - 1
    end
  end
end
