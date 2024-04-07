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
            type: @type
          }.tap do |hash|
            hash[:value] = field.value unless @type.to_sym == :file
          end
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
