# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Label < BaseComponent
        def template(&content)
          content ||= proc { field.key.to_s.titleize }
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
