module Protoform
  module Rails
    module Components
      class TextareaComponent < FieldComponent
        def template(&content)
          content ||= proc { dom.value }
          textarea(**attrs, &content)
        end
      end
    end
  end
end
