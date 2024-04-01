# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Button < FieldComponent
        def template(&content)
          content ||= proc { button_text }
          button(**attrs, &content)
        end

        private

        def button_text
          attrs.fetch(:value, dom.value).titleize
        end

        def default_attributes
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
