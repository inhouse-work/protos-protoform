# frozen_string_literal: true

module Protoform
  class Field < Node
    attr_reader :dom, :object

    # @param key [Symbol] the key for this field
    # @param parent [Protoform::Form, Protoform::FieldCollection] the parent
    # @param object [Object, nil] the object to read/write values from/to
    # @param value [Object, nil] the value to use if no object is given
    def initialize(key, parent:, object: nil, value: nil)
      super(key, parent:)
      @object = object
      @value = value
      @dom = Protoform::DOM.new(field: self)
    end

    # Get the value of this field, either from the object or from the value.
    # @return [Object] the value of this field
    def value
      return @value if @value
      return unless @object.respond_to? @key.to_s

      @object.send @key
    end

    alias serialize value

    # Set the value of this field, either on the object or on the value.
    # @param value [Object] the value to set
    def assign(value)
      if @object.respond_to? :"#{@key}="
        @object.send :"#{@key}=", value
      else
        @value = value
      end
    end

    alias value= assign

    # Wraps a field that's an array of values with a bunch of fields
    # that are indexed with the array's index. Passing a block will yield each
    # of the indexed fields to the block. If no block is given, an `Enumerator`
    # is returned instead.
    #
    # @example
    #   field(:tag_ids).collection do |field|
    #     field.label do
    #       field.input(type: "checkbox", value: field.value)
    #     end
    #   end
    #
    #   enum = field(:tag_ids).collection
    #   enum.each do |field|
    #     field.label do
    #         field.input(type: "checkbox", value: field.value)
    #       end
    #     end
    #   end
    #
    #   # We can also change the value the field enumerates over
    #   field(:tag_ids, value: [1, 2, 3]).collection.each do |field|
    #     # ...
    #   end
    #
    # @return [Enumerator]
    # @yield [Protoform::Field] each field in the collection
    def collection(&)
      @collection ||= FieldCollection.new(field: self, &)
    end
  end
end
