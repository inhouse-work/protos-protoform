# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Submit < Protoform::Rails::Component
        param :value, default: -> { "Submit" }
        option :disable_with, default: -> { "Submitting..." }

        def view_template
          input(type: :submit, **attrs)
        end

        private

        def default_attrs
          {
            value:,
            name: "commit",
            data: { disable_with: }
          }
        end
      end
    end
  end
end
