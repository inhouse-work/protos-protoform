# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Time < Input
        option :value, default: -> { field.value }
        option :include_seconds, default: -> { true }, reader: false
        option :min, default: -> { }
        option :max, default: -> { }

        private

        def default_attrs
          super.merge(
            {
              type: "time",
              value: time_value(value)
            }
          ).tap do |attrs|
            attrs[:min] = time_value(min) if min
            attrs[:max] = time_value(max) if max
          end
        end

        def time_value(value)
          return unless value

          if value.is_a?(String)
            value = begin
              Datetime.parse(value)
            rescue Date::Error
              nil
            end
          end

          if @include_seconds
            value.strftime("%T.%L")
          else
            value.strftime("%H:%M")
          end
        end
      end
    end
  end
end
