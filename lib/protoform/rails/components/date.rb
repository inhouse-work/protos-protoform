# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Date < Input
        option :value, default: -> { field.value }
        option :min, default: -> { }
        option :max, default: -> { }

        private

        def default_attrs
          super.merge(
            {
              type: "date",
              value: date_value(value)
            }
          ).tap do |attrs|
            attrs[:min] = date_value(min) if min
            attrs[:max] = date_value(max) if max
          end
        end

        def date_value(value)
          return unless value

          if value.is_a?(String)
            value = begin
              Datetime.parse(value)
            rescue Date::Error
              nil
            end
          end

          value.strftime("%Y-%m-%d")
        end
      end
    end
  end
end
