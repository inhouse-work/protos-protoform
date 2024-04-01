# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Input < FieldComponent
        def template
          input(**attrs)
        end

        private

        def default_attributes
          {
            id: dom.id,
            name: dom.name,
            value: dom.value,
            type:
          }
        end

        def type
          case field.value
          when URI
            "url"
          when Integer
            "number"
          when Date, DateTime
            "date"
          when Time
            "time"
          else
            "text"
          end
        end
      end
    end
  end
end
