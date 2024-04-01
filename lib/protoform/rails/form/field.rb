module Protoform
  module Rails
    class Form
      # The Field class is designed to be extended to create custom forms. To
      # override, in your subclass you may have something like this:
      #
      # ```ruby
      # class MyForm < Protoform::Rails::Form
      #   class MyLabel < Protoform::Rails::Components::LabelComponent
      #     def template(&content)
      #       label(form: @field.dom.name, class: "text-bold", &content)
      #     end
      #   end
      #
      #   class Field < Field
      #     def label(**attributes)
      #       MyLabel.new(self, **attributes)
      #     end
      #   end
      # end
      # ```
      #
      # Now all calls to `label` will have the `text-bold` class applied to it.
      class Field < Protoform::Field
        def button(...)
          Components::ButtonComponent.new(self, ...)
        end

        def input(...)
          Components::InputComponent.new(self, ...)
        end

        def checkbox(...)
          Components::CheckboxComponent.new(self, ...)
        end

        def label(...)
          Components::LabelComponent.new(self, ...)
        end

        def textarea(...)
          Components::TextareaComponent.new(self, ...)
        end

        def select(*collection, **attributes, &)
          Components::SelectField.new(
            self,
            collection: collection,
            **attributes,
            &
          )
        end

        def title
          key.to_s.titleize
        end
      end
    end
  end
end
