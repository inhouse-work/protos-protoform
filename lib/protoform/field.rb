# frozen_string_literal: true

module Protoform
  class Field < Node
    attr_reader :dom

    def initialize(key, parent:, object: nil, value: nil)
      super(key, parent:)
      @object = object
      @value = value
      @dom = Protoform::DOM.new(field: self)
    end

    def value
      if @object.respond_to? @key.to_s
        @object.send @key
      else
        @value
      end
    end
    alias serialize value

    def assign(value)
      if @object.respond_to? :"#{@key}="
        @object.send :"#{@key}=", value
      else
        @value = value
      end
    end
    alias value= assign

    # Wraps a field that's an array of values with a bunch of fields
    # that are indexed with the array's index.
    def collection(&block)
      @collection ||= FieldCollection.new(field: self, &block)
    end
  end
end
