# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Select < FieldComponent
        option :collection, default: -> { [] }
        option :include_blank, default: -> { true }
        option :multiple, reader: false, default: -> { false }

        def template(&options)
          name = @multiple ? "#{attrs[:name]}[]" : attrs[:name]

          if @multiple
            input(
              name:,
              type: :hidden,
              value: ""
            )
          end

          if options
            select(multiple: @multiple, **attrs, name:, &options)
          else
            select(multiple: @multiple, **attrs, name:) do
              blank_option
              options(*@collection)
            end
          end
        end

        def options(*collection)
          map_options(collection).each do |key, value|
            option(
              selected: selected_value_for(key) ? "selected" : false,
              value: key
            ) { value }
          end
        end

        def blank_option(&block)
          option(selected: field.value.nil?, &block)
        end

        def true_option(&block)
          option(selected: field.value == true, value: true.to_s, &block)
        end

        def false_option(&block)
          option(selected: field.value == false, value: false.to_s, &block)
        end

        protected

        def selected_value_for(key)
          case field.value
          when String, Symbol
            field.value.to_s == key.to_s
          when Array
            field.value.include?(key)
          else
            field.value == key
          end
        end

        def map_options(collection)
          OptionMapper.new(collection)
        end
      end
    end
  end
end
