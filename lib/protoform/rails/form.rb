# frozen_string_literal: true

module Protoform
  module Rails
    # A Protos::Component class that accepts a model and sets
    # a `Protoform::Namespace` with the `Object#model_name` as the key and maps
    # the object to form fields and namespaces.
    #
    # The `Form::Field` is a class that's meant to be extended so you can
    # customize the `Form` inputs to your applications needs. Defaults for the
    # `input`, `button`, `label`, and `textarea` tags are provided.
    #
    # The `Form` component also handles Rails authenticity tokens via the
    # `authenticity_toklen_field` method and the HTTP verb via the
    # `_method_field`.
    class Form < Component
      param :model, reader: false
      option :authenticity_token, reader: false, default: -> { true }
      option :helpers, reader: false, default: -> {}
      option :action, reader: false, default: -> {}
      option :method,
             reader: false,
             default: -> {}
      option :namespace, reader: false, default: -> do
        Namespace.root(key, object: @model, field_class: self.class::Field)
      end

      def field(...)
        @namespace.field(...)
      end

      def collection(...)
        @namespace.collection(...)
      end

      def namespace(...)
        @namespace.namespace(...)
      end

      def assign(...)
        @namespace.assign(...)
      end

      def serialize(...)
        @namespace.serialize(...)
      end

      def around_template(&block)
        form_tag do
          authenticity_token_field if @authenticity_token

          _method_field
          super
        end
      end

      def form_tag(&block)
        form(
          action: form_action,
          method: form_method,
          **attrs,
          &block
        )
      end

      def view_template(&block)
        yield_content(&block)
      end

      def submit(value = submit_value, **attributes)
        input(
          **attributes.merge(
            name: "commit",
            type: "submit",
            value:
          )
        )
      end

      def key
        @model.model_name.param_key
      end

      protected

      def authenticity_token_field
        input(
          name: "authenticity_token",
          type: "hidden",
          value: helpers.form_authenticity_token
        )
      end

      def _method_field
        input(
          name: "_method",
          type: "hidden",
          value: _method_field_value
        )
      end

      def _method_field_value
        @method || (@model.persisted? ? "patch" : "post")
      end

      def submit_value
        "#{resource_action.to_s.capitalize} #{@model.model_name}"
      end

      def resource_action
        return :update if @method == :patch

        @model.persisted? ? :update : :create
      end

      def form_action
        @form_action ||= @action || helpers.url_for(action: resource_action)
      end

      def form_method
        @method == :get ? :get : :post
      end

      private

      def helpers
        @helpers ||= super
      end
    end
  end
end
