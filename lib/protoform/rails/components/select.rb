module Protoform
  module Rails
    module Components
      class SelectField < FieldComponent
        option :collection, default: -> { [] }

        def template(&options)
          if options
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

        def map_options(collection)
          OptionMapper.new(collection)
        end
      end
    end
  end
end
