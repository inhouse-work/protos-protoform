# frozen_string_literal: true

module Protoform
  module Rails
    class Form
      # The Field class is designed to be extended to create custom forms. To
      # override, in your subclass you may have something like this:
      #
      # ```ruby
      # class MyForm < Protoform::Rails::Form
      #   class MyLabel < Protoform::Rails::Components::LabelComponent
      #     def view_template(&content)
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
          Components::Button.new(self, ...)
        end

        def input(...)
          Components::Input.new(self, ...)
        end

        def checkbox(...)
          Components::Checkbox.new(self, ...)
        end

        def radio_button(value, **)
          Components::RadioButton.new(self, value:, **)
        end

        def label(...)
          Components::Label.new(self, ...)
        end

        def textarea(...)
          Components::Textarea.new(self, ...)
        end

        def select(*collection, **attributes, &block)
          Components::Select.new(
            self,
            collection:,
            **attributes,
            &block
          )
        end

        def title
          key.to_s.titleize
        end
      end
    end
  end
end
