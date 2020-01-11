# frozen_string_literal: true

module Components
  module_function

  def load
    COMPONENTS.map do |component|
      component_class(component[:class]).new(
        component[:options]
      ) unless component[:disabled]
    end.compact
  end

  def component_class(class_name)
    Kernel.const_get("Components::#{class_name}")
  end
end
