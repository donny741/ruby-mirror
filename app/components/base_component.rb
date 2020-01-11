# frozen_string_literal: true

module Components
  class BaseComponent
    attr_reader :opts, :update_interval

    def initialize(opts)
      @opts = opts
      @update_interval = opts[:update_interval]
    end
  end
end
