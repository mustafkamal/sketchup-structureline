module Mustafa
  module StructureLine
    module Contractor
      module Component
        class ConcreteBox < BaseComponent

          include Utils::Constants

          attr_accessor :pts, :vector, :soft_edge_vector

          def initialize(element, pts, vector, presentation, description, id = SecureRandom.uuid)
            @element = element
            @pts = pts
            @vector = vector
            @presentation = presentation
            @description = description
            @id = id
            @type = COMPONENT_TYPE_CONCRETE_BOX
          end

          def create_3d_model
            super
            extrude_face
            soften_edges if @soft_edge_vector
          end

          private

          def extrude_face
            base_face = @entities.add_face(@pts)
            base_face.reverse! unless base_face.normal.samedirection?(@vector)
            base_face.pushpull(@vector.length)
          end

          def soften_edges
            @entities.grep(Sketchup::Edge).each do |edge|
              next if need_to_soften?(edge)
              edge.soft = true
              edge.smooth = true
            end
          end

          def need_to_soften?(edge)
            vector = edge.start.position.vector_to(edge.end.position)
            vector.perpendicular?(@soft_edge_vector)
          end

        end
      end
    end
  end
end