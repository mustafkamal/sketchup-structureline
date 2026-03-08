module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Fabricator
            module SimpleFabricator
              extend self
              include Utils::Constants

              ELEMENT_TYPE_MAP = {
                ELEMENT_TYPE_WALL => :extrude_base_face_upward_until_height,
                ELEMENT_TYPE_COLUMN => :extrude_base_face_upward_until_height,
                ELEMENT_TYPE_RC_BEAM => :extrude_base_face_upward_until_height
              }

              def begin_fabrication(element)
                establish_element_objects(element)
                fabricate_based_on_style
              end

              private

              def establish_element_objects(element)
                @element = element
                @type = @element.type
                @style = @element.style
                @entities = @element.entities
                @extrusion_points = @element.extrusion_points
              end

              def fabricate_based_on_style
                method = ELEMENT_TYPE_MAP[@type]
                raise ArgumentError, "Simple fabricator does not recognized element type" unless method
                send(method)
              end

              def extrude_base_face_upward_until_height
                base_face = @entities.add_face(@extrusion_points[0..3])
                base_face.reverse! unless base_face.normal.samedirection?(Z_AXIS)
                base_face.pushpull(@element.height)
              end

            end
          end
        end
      end
    end
  end
end