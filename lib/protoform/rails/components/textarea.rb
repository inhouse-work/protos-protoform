module Protoform
  module Rails
    module Components
      class TextareaComponent < FieldComponent
        def template(&content)
          content ||= Proc.new { dom.value }
          textarea(**attrs, &content)
        end
      end
    end
  end
end
