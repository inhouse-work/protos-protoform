# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Label < Component
        option :value, default: -> { }

        def view_template(&content)
          content ||= proc { title }
          label(**attrs, &content)
        end

        private

        def label_id
          return dom.id unless value

          [dom.id, value.to_s.parameterize.underscore].join("_")
        end

        def default_attrs
          {
            for: label_id
          }
        end
      end
    end
  end
end
