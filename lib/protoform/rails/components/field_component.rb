# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class FieldComponent < Component
        private

        def default_attrs
          {
            id: dom.id,
            name: dom.name
          }
        end
      end
    end
  end
end
