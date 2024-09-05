# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class RadioButton < Input
        # This makes value manditory in this class instead of being absorbed by
        # the html_options hash from Protos.
        option :value

        private

        def radio_id
          [dom.id, value.to_s.parameterize.underscore].join("_")
        end

        def checked?
          dom.value == field.value
        end

        def default_attrs
          {
            id: radio_id,
            name: dom.name,
            value:,
            type: "radio",
            checked: checked? ? "checked" : false
          }
        end
      end
    end
  end
end
