# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Datetime < Input
        # This makes value manditory in this class instead of being absorbed by
        # the html_options hash from Protos.

        option :value, default: -> { field.value }
        option :include_seconds, default: -> { true }, reader: false
        option :min, default: -> { }
        option :max, default: -> { }

        private

        def default_attrs
          super.merge(
            {
              type: "datetime-local",
              value: datetime_value(value)
            }
          ).tap do |attrs|
            attrs[:min] = datetime_value(min) if min
            attrs[:max] = datetime_value(max) if max
          end
        end

        def datetime_value(value)
          return unless value

          if value.is_a?(String)
            value = begin
              Datetime.parse(value)
            rescue StandardError
              nil
            end
          end

          if @include_seconds
            value.strftime("%Y-%m-%dT%T")
          else
            value.strftime("%Y-%m-%dT%H:%M")
          end
        end
      end
    end
  end
end
