# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Input < FieldComponent
        option :type, reader: false, default: -> { inferred_type }

        def view_template
          input(**attrs)
        end

        private

        def default_attrs
          {
            id: dom.id,
            name: dom.name,
            type: @type,
            value:
          }
        end

        def client_provided_value?
          {
            file: true,
            image: true
          }.fetch(@type.to_sym, false)
        end

        def value
          dom.value unless client_provided_value?
        end

        def inferred_type
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
