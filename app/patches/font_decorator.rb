# frozen_string_literal: true

module FontDecorator
  def self.prepended(base)
    class << base
      extend FontDecorator
    end
  end

  def default
    return DEFAULT_FONT if defined?(DEFAULT_FONT)

    if all.include? 'arial'
      path 'arial'
    else
      all_paths.first
    end
  end
end

Ruby2D::Font.singleton_class.prepend(FontDecorator)
