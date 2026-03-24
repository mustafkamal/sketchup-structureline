require 'securerandom'

module Mustafa
  module StructureLine
    module Contractor
      module Component
        class Brick < BaseComponent

          include Utils::Constants

          attr_reader :pts, :vector

          def initialize(element, pts, vector, presentation, description, id = SecureRandom.uuid)
            @element = element
            @pts = pts
            @vector = vector
            @presentation = presentation
            @description = description
            @id = id
            @type = COMPONENT_TYPE_BRICK
          end
        end
      end
    end
  end
end