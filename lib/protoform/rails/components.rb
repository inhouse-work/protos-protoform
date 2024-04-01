module Protoform
  module Rails
    module Components
      class BaseComponent < Protos::Component
        option :field

        def dom
          field.dom
        end
      end

      class FieldComponent < BaseComponent
        private

        def default_attributes
          { id: dom.id, name: dom.name }
        end
      end

      class LabelComponent < BaseComponent
        def template(&content)
          content ||= Proc.new { field.key.to_s.titleize }
          label(**attrs, &content)
        end

        private

        def default_attributes
          { for: dom.id }
        end
      end

      class ButtonComponent < FieldComponent
        def template(&content)
          content ||= Proc.new { button_text }
          button(**attrs, &content)
        end

        private

        def button_text
          attrs.fetch(:value, dom.value).titleize
        end

        def default_attributes
          { id: dom.id, name: dom.name, value: dom.value }
        end
      end

      class CheckboxComponent < FieldComponent
        def template(&)
          # Rails has a hidden and checkbox input to deal with sending back
          # a value to the server regardless of if the input is checked or not.
          input(name: dom.name, type: :hidden, value: "0")
          # The hard coded keys need to be in here so the user can't overrite
          # them.
          input(type: :checkbox, value: "1", **attrs)
        end

        private

        def default_attributes
          { id: dom.id, name: dom.name, checked: field.value }
        end
      end

      class InputComponent < FieldComponent
        def template(&)
          input(**attrs)
        end

        prviate

        def default_attributes
          { id: dom.id, name: dom.name, value: dom.value, type: type }
        end

        def type
          case field.value
          when URI
            "url"
          when Integer
            "number"
          when Date, DateTime
            "date"
          when Time
            "time"
          else
            "text"
          end
        end
      end

      class TextareaComponent < FieldComponent
        def template(&content)
          content ||= Proc.new { dom.value }
          textarea(**attrs, &content)
        end
      end

      class SelectField < FieldComponent
        def initialize(*, collection: [], **, &)
          super(*, **, &)
          @collection = collection
        end

        def template(&options)
          if block_given?
            select(**attributes, &options)
          else
            select(**attributes) { options(*@collection) }
          end
        end

        def options(*collection)
          map_options(collection).each do |key, value|
            option(selected: field.value == key, value: key) { value }
          end
        end

        def blank_option(&)
          option(selected: field.value.nil?, &)
        end

        def true_option(&)
          option(selected: field.value == true, value: true.to_s, &)
        end

        def false_option(&)
          option(selected: field.value == false, value: false.to_s, &)
        end

        protected
          def map_options(collection)
            OptionMapper.new(collection)
          end
      end
    end
  end
end
