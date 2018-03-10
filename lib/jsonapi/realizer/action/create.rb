module JSONAPI
  module Realizer
    class Action
      class Create < Action
        def initialize(payload:, headers:)
          @payload = payload
          @headers = headers
          @resource = resource_class.new(
            relation.new
          )
        end

        def call
          resource.model.tap do |model|
            resource_class.write_attributes_via_call(model, {id: id}) if id
            resource_class.write_attributes_via_call(model, attributes.select(&resource_class.method(:valid_attribute?)))
            resource_class.write_attributes_via_call(model, relationships.select(&resource_class.method(:valid_relationship?)).transform_values(&resource.method(:as_relationship)))
            resource_class.save_via_call(model)
          end
        end
      end
    end
  end
end
