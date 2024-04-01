module Protoform
  module Rails
    module Components
      class BaseComponent < Protos::Component
        param :field

        def dom
          field.dom
        end
      end
    end
  end
end
