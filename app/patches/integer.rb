# frozen_string_literal: true

class Integer
  def vh
    (Window.width * (to_f / 100)).to_i
  end

  def vw
    (Window.height * (to_f / 100)).to_i
  end
end
