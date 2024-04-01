module Protoform
  module Rails
    module Components
      class Label < BaseComponent
        def template(&content)
          content ||= Proc.new { field.key.to_s.titleize }
          label(**attrs, &content)
        end

        private

        def default_attributes
          {
            for: dom.id
          }
        end
      end
    end
  end
end
