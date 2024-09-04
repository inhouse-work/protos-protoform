# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Label < Component
        def view_template(&content)
          content ||= proc { title }
          label(**attrs, &content)
        end

        private

        def default_attrs
          {
            for: dom.id
          }
        end
      end
    end
  end
end
