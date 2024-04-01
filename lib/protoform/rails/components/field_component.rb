module Protoform
  module Rails
    module Components
      class FieldComponent < BaseComponent
        private

        def default_attributes
          {
            id: dom.id,
            name: dom.name
          }
        end
      end
    end
  end
end
