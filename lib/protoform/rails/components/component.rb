# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Component < Protos::Component
        param :field

        def dom
          field.dom
        end
      end
    end
  end
end
