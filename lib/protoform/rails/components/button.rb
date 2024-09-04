# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Button < FieldComponent
        def view_template(&content)
          content ||= proc { button_text }
          button(**attrs, &content)
        end

        private

        def button_text
          text = attrs[:value] || dom.value
          text.titleize
        end

        def default_attrs
          {
            id: dom.id,
            name: dom.name,
            value: dom.value
          }
        end
      end
    end
  end
end
