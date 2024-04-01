# frozen_string_literal: true

module Protoform
  class NamespaceCollection < Node
    include Enumerable

    def initialize(key, parent:, &template)
      super(key, parent:)
      @template = template
      @namespaces = enumerate(parent_collection)
    end

    def serialize
      map(&:serialize)
    end

    def assign(array)
      # The problem with zip-ing the array is if I need to add new
      # elements to it and wrap it in the namespace.
      zip(array) do |namespace, hash|
        namespace.assign hash
      end
    end

    def each(&block)
      @namespaces.each(&block)
    end

    private

    def enumerate(enumerator)
      Enumerator.new do |y|
        enumerator.each.with_index do |object, key|
          y << build_namespace(key, object:)
        end
      end
    end

    def build_namespace(index, **kwargs)
      parent.class.new(
        index,
        parent: self,
        **kwargs,
        &@template
      )
    end

    def parent_collection
      raise_missing_object unless @parent.respond_to? :object
      @parent.object.send(@key).tap do |value|
        raise_invalid_enumerator(value) unless value.respond_to? :each
      end
    end

    def raise_invalid_enumerator(value)
      raise(
        ArgumentError,
        <<~ERROR
          #{@parent.object.class} did not return something that responds to
          :each for #{@key}. #{self.class} requires the model to return
          something that can be enumerated for #{@key}.
          Got #{value.class}: #{value.inspect} instead.
        ERROR
      )
    end

    def raise_missing_object
      raise(
        ArgumentError,
        "Parent of a #{self.class} must respond to :object, " \
        "#{@parent.class} does not"
      )
    end
  end
end
