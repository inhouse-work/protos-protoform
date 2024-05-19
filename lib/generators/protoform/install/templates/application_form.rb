# frozen_string_literal: true

class ApplicationForm < Protoform::Rails::Form
  include Phlex::Rails::Helpers::Pluralize

  # These are the current dry-initializer options for the base class:
  #
  # param :model, reader: false
  # option :helpers, reader: false, default: -> {}
  # option :action, reader: false, default: -> {}
  # option :method, reader: false, default: -> {}
  # option :namespace, reader: false, default: -> do
  #   Namespace.root(key, object: @model, field_class: self.class::Field)
  # end

  def row(component)
    div do
      render component.field.label(style: "display: block;")
      render component
    end
  end

  def around_template(&block)
    super do
      error_messages
      yield
      submit
    end
  end

  def error_messages
    return if model.errors.none?

    div(style: "color: red;") do
      h2 do
        "#{pluralize model.errors.count,
                     "error"} prohibited this post from being saved:"
      end
      ul do
        model.errors.each do |error|
          li { error.full_message }
        end
      end
    end
  end
end
