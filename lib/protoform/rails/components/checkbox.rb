# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Checkbox < FieldComponent
        option :include_hidden, default: -> { true }
        option :checked_value, default: -> { "1" }
        option :unchecked_value, default: -> { "0" }
        option :checked, default: -> { field.value }

        def view_template
          # Rails has a hidden and checkbox input to deal with sending back
          # a value to the server regardless of if the input is checked or not.
          if include_hidden
            input(
              type: :hidden,
              value: unchecked_value,
              autocomplete: "off",
              **attrs.to_hash.slice(:name)
            )
          end
          # The hard coded keys need to be in here so the user can't overrite
          # them.
          input(type: :checkbox, value: checked_value, **attrs)
        end

        private

        def default_attrs
          {
            id: dom.id,
            name: dom.name,
            checked:
          }
        end
      end
    end
  end
end
