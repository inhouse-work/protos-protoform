# frozen_string_literal: true

require "active_support/core_ext/string/inflections"

module Protoform
  module Rails
    module Components
      class Component < Protoform::Rails::Component
        param :field

        def dom
          field.dom
        end

        def title
          field.key.to_s.titleize
        end
      end
    end
  end
end
